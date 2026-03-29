import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景
                LinearGradient(
                    colors: [.blue.opacity(0.4), .purple.opacity(0.4), .pink.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 遊戲區域
                    ZStack {
                        // 危險線
                        VStack {
                            Rectangle()
                                .fill(.red.opacity(0.5))
                                .frame(height: 2)
                                .padding(.top, BopomofoConstants.dangerLineY)
                            
                            Text("⚠️ 危險線 ⚠️")
                                .font(.caption)
                                .foregroundColor(.red)
                                .bold()
                            
                            Spacer()
                        }
                        
                        // 掉落的字卡
                        ForEach(viewModel.cards) { card in
                            CardView(card: card)
                                .position(card.position)
                                .onTapGesture {
                                    viewModel.removeCard(withCharacter: card.character)
                                }
                        }
                        
                        // 頂部UI
                        VStack {
                            HStack {
                                Text("分數: \(viewModel.score)")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                                
                                Spacer()
                                
                                Button(action: {
                                    if viewModel.gameStatus == .playing {
                                        viewModel.pauseGame()
                                    } else {
                                        viewModel.resumeGame()
                                    }
                                }) {
                                    Text(viewModel.gameStatus == .playing ? "暫停" : "繼續")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(.white)
                                        .cornerRadius(20)
                                }
                            }
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.black.opacity(0.3), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            
                            Spacer()
                        }
                        
                        // 鍵盤提示
                        if viewModel.showKeyboardHint {
                            VStack {
                                Text("點下方注音鍵盤!")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(.yellow)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .padding(.top, 80)
                                
                                Spacer()
                            }
                        }
                    }
                    .frame(height: geometry.size.height - 220)
                    .onAppear {
                        viewModel.gameAreaSize = CGSize(
                            width: geometry.size.width,
                            height: geometry.size.height - 220
                        )
                    }
                    
                    // 虛擬鍵盤
                    VirtualKeyboardView(viewModel: viewModel)
                        .frame(height: 220)
                }
                
                // 暫停/結束畫面
                if viewModel.gameStatus == .paused {
                    PauseOverlayView(viewModel: viewModel)
                } else if viewModel.gameStatus == .gameOver {
                    GameOverOverlayView(viewModel: viewModel)
                }
            }
        }
    }
}
