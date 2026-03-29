import SwiftUI

struct GameOverOverlayView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("字卡堆滿了!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.red)
                
                Text("本局分數")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Text("\(viewModel.score)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.purple)
                
                if viewModel.score > viewModel.highScore {
                    Text("🎉 新紀錄! 🎉")
                        .font(.title2.bold())
                        .foregroundColor(.yellow)
                }
                
                Text("最高分: \(viewModel.highScore)")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("再玩一次")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.purple)
                        .cornerRadius(15)
                }
                
                Button(action: {
                    viewModel.gameStatus = .bopomofoMenu
                }) {
                    Text("回到主選單")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gray)
                        .cornerRadius(15)
                }
            }
            .padding(40)
            .background(.white)
            .cornerRadius(25)
            .shadow(radius: 20)
            .padding(30)
        }
    }
}
