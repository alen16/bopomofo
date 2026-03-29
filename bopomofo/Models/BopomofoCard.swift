import SwiftUI

struct BopomofoCard: Identifiable, Equatable {
    let id = UUID()
    let character: String        // 注音符號 (ㄅ, ㄆ, etc.)
    var position: CGPoint        // 當前位置
    let color: Color            // 背景顏色
    var rotation: Double         // 旋轉角度
    var speed: Double           // 掉落速度
    var isResting: Bool         // 是否已停止(用於堆疊檢測)
    
    static func == (lhs: BopomofoCard, rhs: BopomofoCard) -> Bool {
        lhs.id == rhs.id
    }
}
