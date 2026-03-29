import SwiftUI

struct FlashcardView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedCharacter: String? = nil
    @State private var bounceScale: CGFloat = 1.0

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)
    private let audioService = AudioService.shared

    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                colors: [.blue.opacity(0.5), .purple.opacity(0.5), .pink.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // 頂部導航列
                HStack {
                    Button(action: {
                        viewModel.exitLearningMode()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("返回")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.3))
                        .cornerRadius(20)
                    }
                    Spacer()
                    // 完成學習並獲得 1 顆星
                    Button(action: {
                        viewModel.completeFlashcardSession()
                    }) {
                        HStack(spacing: 6) {
                            Text("⭐")
                            Text("完成學習")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal)

                // 標題
                Text("注音學習卡")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                Text("點擊卡片聽發音 🔊")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))

                // 字卡網格
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(BopomofoConstants.allCharacters.enumerated()), id: \.offset) { index, character in
                            FlashcardCell(
                                character: character,
                                color: BopomofoConstants.cardColors[index % BopomofoConstants.cardColors.count],
                                isSelected: selectedCharacter == character
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    selectedCharacter = character
                                }
                                audioService.pronounce(character)
                                // 取消選中狀態
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        if selectedCharacter == character {
                                            selectedCharacter = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 8)
        }
    }
}

struct FlashcardCell: View {
    let character: String
    let color: Color
    let isSelected: Bool

    var body: some View {
        Text(character)
            .font(.system(size: isSelected ? 32 : 28, weight: .bold))
            .frame(width: isSelected ? 72 : 64, height: isSelected ? 72 : 64)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(color)
                    .shadow(color: isSelected ? color.opacity(0.8) : .black.opacity(0.15),
                            radius: isSelected ? 12 : 4,
                            x: 0, y: isSelected ? 2 : 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.white, lineWidth: isSelected ? 4 : 2)
            )
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSelected)
    }
}
