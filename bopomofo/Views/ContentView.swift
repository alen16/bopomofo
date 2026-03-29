import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            switch viewModel.gameStatus {
            case .hub:
                HubView(viewModel: viewModel)
            case .bopomofoMenu:
                BopomofoMenuView(viewModel: viewModel)
            case .playing, .paused, .gameOver:
                GameView(viewModel: viewModel)
            case .learning:
                FlashcardView(viewModel: viewModel)
            case .soundMatch:
                SoundMatchView(viewModel: viewModel)
            }
        }
        #if os(iOS)
        .statusBar(hidden: true)
        #endif
    }
}
