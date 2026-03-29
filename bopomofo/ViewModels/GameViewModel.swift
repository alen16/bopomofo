import SwiftUI
import Combine

@MainActor
class GameViewModel: ObservableObject {
    @Published var cards: [BopomofoCard] = []
    @Published var score: Int = 0
    @Published var highScore: Int = 0
    @Published var gameStatus: GameStatus = .hub
    @Published var settings: GameSettings = GameSettings()
    @Published var showKeyboardHint: Bool = true
    @Published var gameAreaSize: CGSize = .zero
    @Published var userProgress: UserProgress = UserProgress()
    @Published var showStreakCelebration: Bool = false

    private var gameTimer: Timer?
    private var spawnTimer: Timer?
    private let audioService = AudioService.shared
    private let storageService = StorageService.shared

    init() {
        loadSettings()
        loadHighScore()
        loadUserProgress()
    }

    // MARK: - 導航控制
    func enterHub() {
        gameStatus = .hub
    }

    func enterBopomofoMenu() {
        gameStatus = .bopomofoMenu
    }

    func enterSoundMatch() {
        gameStatus = .soundMatch
    }

    func exitSoundMatch() {
        gameStatus = .bopomofoMenu
    }

    // MARK: - 遊戲控制
    func startGame() {
        gameStatus = .playing
        score = 0
        cards = []
        showKeyboardHint = true
        startGameLoop()
        scheduleNextSpawn()
    }

    func pauseGame() {
        gameStatus = .paused
        stopGameLoop()
    }

    func resumeGame() {
        gameStatus = .playing
        startGameLoop()
        scheduleNextSpawn()
    }

    func endGame() {
        gameStatus = .gameOver
        stopGameLoop()
        if score > highScore {
            highScore = score
            storageService.saveHighScore(score)
        }
        // 掉落遊戲: 每 10 分得 1 顆星
        let starsEarned = score / 10
        if starsEarned > 0 {
            recordActivity(stars: starsEarned)
        }
    }

    func enterLearningMode() {
        gameStatus = .learning
    }

    func exitLearningMode() {
        gameStatus = .bopomofoMenu
    }

    /// Call when flashcard session is explicitly "completed" by user tap.
    func completeFlashcardSession() {
        recordActivity(stars: 1)
        gameStatus = .bopomofoMenu
    }

    // MARK: - 進度 / 連勝 / 星星
    func recordActivity(stars: Int) {
        let streakIncreased = userProgress.recordActivity(stars: stars)
        storageService.saveUserProgress(userProgress)
        if streakIncreased {
            showStreakCelebration = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.showStreakCelebration = false
            }
        }
    }

    // MARK: - 遊戲循環
    private func startGameLoop() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
            self?.updateCards()
        }
    }

    private func stopGameLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
        spawnTimer?.invalidate()
        spawnTimer = nil
    }

    // MARK: - 卡片生成
    private func scheduleNextSpawn() {
        let interval = getSpawnInterval()
        spawnTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.spawnCard()
            if self?.gameStatus == .playing {
                self?.scheduleNextSpawn()
            }
        }
    }

    private func spawnCard() {
        let randomX = CGFloat.random(in: 0...(gameAreaSize.width - BopomofoConstants.cardSize))
        let randomChar = BopomofoConstants.allCharacters.randomElement() ?? "ㄅ"
        let randomColor = BopomofoConstants.cardColors.randomElement() ?? .blue

        let newCard = BopomofoCard(
            character: randomChar,
            position: CGPoint(x: randomX, y: -BopomofoConstants.cardSize),
            color: randomColor,
            rotation: 0,
            speed: getSpeed(),
            isResting: false
        )

        cards.append(newCard)
    }

    // MARK: - 卡片更新 (物理模擬)
    private func updateCards() {
        var updatedCards: [BopomofoCard] = []

        for card in cards {
            var updatedCard = card

            if !card.isResting {
                // 更新Y座標
                updatedCard.position.y += card.speed

                // 檢查是否碰到底部
                let bottomY = gameAreaSize.height - BopomofoConstants.cardSize
                if updatedCard.position.y >= bottomY {
                    updatedCard.position.y = bottomY
                    updatedCard.isResting = true
                } else {
                    // 檢查是否碰到其他卡片
                    let restingY = findRestingPosition(for: updatedCard, in: cards)
                    if updatedCard.position.y >= restingY {
                        updatedCard.position.y = restingY
                        updatedCard.isResting = true
                    }
                }
            }

            updatedCards.append(updatedCard)
        }

        cards = updatedCards

        // 檢查遊戲失敗條件
        if cards.contains(where: { $0.isResting && $0.position.y <= BopomofoConstants.dangerLineY }) {
            endGame()
        }
    }

    // 找到卡片應該停留的Y座標
    private func findRestingPosition(for card: BopomofoCard, in allCards: [BopomofoCard]) -> CGFloat {
        let bottomY = gameAreaSize.height - BopomofoConstants.cardSize
        var restingY = bottomY

        let nearbyCards = allCards.filter { otherCard in
            otherCard.id != card.id &&
            otherCard.isResting &&
            abs(otherCard.position.x - card.position.x) < BopomofoConstants.cardSize
        }

        for otherCard in nearbyCards {
            if card.position.y + BopomofoConstants.cardSize >= otherCard.position.y {
                let potentialY = otherCard.position.y - BopomofoConstants.cardSize - BopomofoConstants.cardMargin
                if potentialY < restingY {
                    restingY = potentialY
                }
            }
        }

        return restingY
    }

    // MARK: - 消除卡片
    func removeCard(withCharacter character: String) {
        // 找到最底下第一個匹配的卡片
        let sortedCards = cards.sorted { $0.position.y > $1.position.y }
        guard let targetCard = sortedCards.first(where: { $0.character == character }) else {
            return
        }

        // 移除卡片
        cards.removeAll { $0.id == targetCard.id }

        // 重置所有卡片的停止狀態,讓它們重新計算位置
        for index in cards.indices {
            cards[index].isResting = false
        }

        // 增加分數
        score += 1

        // 播放音效
        if settings.soundEnabled {
            audioService.playTapSound()
            audioService.pronounce(character)
        }

        // 震動反饋
        if settings.hapticEnabled {
            audioService.playHaptic()
        }

        // 隱藏提示
        if showKeyboardHint && score >= 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showKeyboardHint = false
            }
        }
    }

    // MARK: - 難度計算
    private func getSpeed() -> Double {
        let baseSpeed = 0.5
        let speedIncrease = Double(score / 20) * 0.1
        return min(1.5, baseSpeed + speedIncrease)
    }

    private func getSpawnInterval() -> TimeInterval {
        let baseInterval: TimeInterval = 3.0
        let intervalDecrease = TimeInterval(score / 20) * 0.2
        return max(1.5, baseInterval - intervalDecrease)
    }

    // MARK: - 資料持久化
    private func loadSettings() {
        if let settings = storageService.loadSettings() {
            self.settings = settings
        }
    }

    private func loadHighScore() {
        highScore = storageService.loadHighScore()
    }

    private func loadUserProgress() {
        userProgress = storageService.loadUserProgress()
    }

    func saveSettings() {
        storageService.saveSettings(settings)
    }

    func resetHighScore() {
        highScore = 0
        storageService.saveHighScore(0)
    }
}
