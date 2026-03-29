import Foundation

enum GameStatus {
    case hub          // 主頁 (新根畫面)
    case bopomofoMenu // 注音子選單 (原 menu)
    case playing
    case paused
    case gameOver
    case learning
    case soundMatch   // 聽音辨字遊戲
}

struct GameSettings: Codable {
    var soundEnabled: Bool = true
    var hapticEnabled: Bool = true
}
