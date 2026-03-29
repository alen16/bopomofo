import SwiftUI

struct VirtualKeyboardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(Array(BopomofoConstants.keyboardLayout.enumerated()), id: \.offset) { index, row in
                HStack(spacing: 4) {
                    ForEach(row, id: \.self) { char in
                        Button(action: {
                            viewModel.removeCard(withCharacter: char)
                        }) {
                            Text(char)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(
                                    LinearGradient(
                                        colors: [.white, .gray.opacity(0.3)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
        .padding(8)
        .background(.white.opacity(0.95))
    }
}

// 按鈕縮放效果
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
