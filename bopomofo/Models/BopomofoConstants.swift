import SwiftUI

struct BopomofoConstants {
    // 所有37個注音符號
    static let allCharacters = [
        "ㄅ","ㄆ","ㄇ","ㄈ","ㄉ","ㄊ","ㄋ","ㄌ",
        "ㄍ","ㄎ","ㄏ","ㄐ","ㄑ","ㄒ","ㄓ","ㄔ",
        "ㄕ","ㄖ","ㄗ","ㄘ","ㄙ","ㄧ","ㄨ","ㄩ",
        "ㄚ","ㄛ","ㄜ","ㄝ","ㄞ","ㄟ","ㄠ","ㄡ",
        "ㄢ","ㄣ","ㄤ","ㄥ","ㄦ"
    ]
    
    // 虛擬鍵盤佈局 (5行)
    static let keyboardLayout: [[String]] = [
        ["ㄅ", "ㄆ", "ㄇ", "ㄈ", "ㄉ", "ㄊ", "ㄋ", "ㄌ"],
        ["ㄍ", "ㄎ", "ㄏ", "ㄐ", "ㄑ", "ㄒ", "ㄓ", "ㄔ"],
        ["ㄕ", "ㄖ", "ㄗ", "ㄘ", "ㄙ", "ㄧ", "ㄨ", "ㄩ"],
        ["ㄚ", "ㄛ", "ㄜ", "ㄝ", "ㄞ", "ㄟ", "ㄠ", "ㄡ"],
        ["ㄢ", "ㄣ", "ㄤ", "ㄥ", "ㄦ"]
    ]
    
    // 鮮豔色彩（高對比，易閱讀）
    static let cardColors: [Color] = [
        Color(red: 1.0,  green: 0.35, blue: 0.35), // 珊瑚紅
        Color(red: 1.0,  green: 0.55, blue: 0.1),  // 橘色
        Color(red: 0.95, green: 0.75, blue: 0.0),  // 金黃
        Color(red: 0.2,  green: 0.72, blue: 0.35), // 翠綠
        Color(red: 0.18, green: 0.55, blue: 0.95), // 天藍
        Color(red: 0.6,  green: 0.25, blue: 0.9),  // 紫色
        Color(red: 0.95, green: 0.3,  blue: 0.7),  // 玫紅
        Color(red: 0.08, green: 0.65, blue: 0.75), // 青綠
        Color(red: 0.85, green: 0.45, blue: 0.1),  // 棕橘
        Color(red: 0.35, green: 0.45, blue: 0.95)  // 靛藍
    ]
    
    static let cardSize: CGFloat = 70
    static let cardMargin: CGFloat = 5
    static let dangerLineY: CGFloat = 100  // 危險線位置
}
