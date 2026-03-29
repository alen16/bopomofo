import Foundation

class StorageService {
    static let shared = StorageService()

    private let highScoreKey = "BopomofoHighScore"
    private let settingsKey = "BopomofoSettings"
    private let userProgressKey = "UserProgress"

    private init() {}

    // MARK: - High Score
    func saveHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: highScoreKey)
    }

    func loadHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: highScoreKey)
    }

    // MARK: - Settings
    func saveSettings(_ settings: GameSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }

    func loadSettings() -> GameSettings? {
        guard let data = UserDefaults.standard.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(GameSettings.self, from: data) else {
            return nil
        }
        return settings
    }

    // MARK: - User Progress (streak, XP, level)
    func saveUserProgress(_ progress: UserProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: userProgressKey)
        }
    }

    func loadUserProgress() -> UserProgress {
        guard let data = UserDefaults.standard.data(forKey: userProgressKey),
              let progress = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return UserProgress()
        }
        return progress
    }
}
