import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                colors: [.blue.opacity(0.6), .purple.opacity(0.6), .pink.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // 標題
                Text("注音掉落")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                Text("Bopomofo Drop")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.9))
                
                // 最高分顯示
                VStack(spacing: 10) {
                    Text("最高分")
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("\(viewModel.highScore)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.purple)
                }
                .padding(30)
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                
                // 開始按鈕
                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("開始遊戲")
                        .font(.title2.bold())
                        .foregroundColor(.purple)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .background(.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)

                // 學習模式按鈕
                Button(action: {
                    viewModel.enterLearningMode()
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("學習模式")
                    }
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 20)
                    .background(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(radius: 10)
                }

                // 設定按鈕
                Button(action: {
                    showSettings = true
                }) {
                    Text("設定")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.3))
                        .cornerRadius(20)
                }
                
                // 說明文字
                VStack(spacing: 8) {
                    Text("如何遊戲")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("點擊下方虛擬鍵盤的注音符號")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    Text("適合 4-7 歲小朋友學習注音!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(.white.opacity(0.2))
                .cornerRadius(15)
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
    }
}
