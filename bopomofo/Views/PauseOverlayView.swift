import SwiftUI

struct PauseOverlayView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("遊戲暫停")
                    .font(.largeTitle.bold())
                    .foregroundColor(.black)
                
                Button(action: {
                    viewModel.resumeGame()
                }) {
                    Text("繼續遊戲")
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
