import SwiftUI

private enum SoundMatchPhase {
    case playing, sessionComplete
}

struct SoundMatchView: View {
    @ObservedObject var viewModel: GameViewModel

    // Game state
    @State private var phase: SoundMatchPhase = .playing
    @State private var round: Int = 1
    @State private var totalRounds: Int = 10
    @State private var correctCount: Int = 0
    @State private var targetCharacter: String = ""
    @State private var choices: [String] = []

    // Animation state
    @State private var wrongChoice: String? = nil
    @State private var shakeOffset: CGFloat = 0
    @State private var showCorrectFlash: Bool = false
    @State private var correctChoice: String? = nil
    @State private var isReadyForNext: Bool = false

    private let speechService = SpeechService.shared
    private let audioService = AudioService.shared

    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                colors: [
                    Color(red: 0.9, green: 0.4, blue: 0.9),
                    Color(red: 0.6, green: 0.2, blue: 1.0),
                    Color(red: 0.2, green: 0.45, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if phase == .playing {
                playingView
            } else {
                sessionCompleteView
            }
        }
        .onAppear {
            setupRound()
        }
    }

    // MARK: - Playing View
    private var playingView: some View {
        VStack(spacing: 0) {
            // 頂部列
            HStack {
                Button {
                    speechService.stopSpeaking()
                    viewModel.exitSoundMatch()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("返回")
                    }
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(20)
                }
                Spacer()
                Text("第 \(round) / \(totalRounds) 題")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // 進度條
            ProgressView(value: Double(round - 1), total: Double(totalRounds))
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .padding(.horizontal, 20)
                .padding(.top, 10)

            Spacer()

            // 提示文字
            Text("聽到哪個注音？")
                .font(.system(size: 26, weight: .black))
                .foregroundColor(.white)
                .shadow(radius: 4)

            // 播放按鈕
            Button {
                playCurrentSound()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 110, height: 110)
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 52))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(BounceButtonStyle())
            .padding(.vertical, 20)
            .shadow(color: .purple.opacity(0.5), radius: 12, x: 0, y: 6)

            Text("點我再聽一次 🔊")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            // 4 個選項
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 16
            ) {
                ForEach(choices, id: \.self) { char in
                    choiceButton(char)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Choice Button
    @ViewBuilder
    private func choiceButton(_ char: String) -> some View {
        let isWrong = wrongChoice == char
        let isCorrect = correctChoice == char

        Button {
            handleChoice(char)
        } label: {
            Text(char)
                .font(.system(size: 52, weight: .black))
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(isCorrect
                              ? Color.green.opacity(0.85)
                              : isWrong
                                ? Color.red.opacity(0.75)
                                : Color.white.opacity(0.9))
                        .shadow(
                            color: isCorrect ? .green.opacity(0.5)
                                : isWrong ? .red.opacity(0.4)
                                : .black.opacity(0.2),
                            radius: 8, x: 0, y: 4
                        )
                )
                .foregroundColor(isCorrect || isWrong ? .white : .black)
                .scaleEffect(isCorrect ? 1.08 : 1.0)
                .offset(x: isWrong ? shakeOffset : 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isCorrect)
        }
        .disabled(correctChoice != nil)
        .buttonStyle(BounceButtonStyle())
    }

    // MARK: - Session Complete View
    private var sessionCompleteView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("太棒了！ 🎉")
                .font(.system(size: 44, weight: .black))
                .foregroundColor(.white)
                .shadow(radius: 6)

            Text("本次結果")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))

            // 分數圓圈
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 160, height: 160)
                VStack(spacing: 4) {
                    Text("\(correctCount)")
                        .font(.system(size: 64, weight: .black))
                        .foregroundColor(.white)
                    Text("/ \(totalRounds) 題答對")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }

            // 星星獎勵
            VStack(spacing: 6) {
                Text("⭐ 獲得 1 顆星！")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)

            Spacer()

            VStack(spacing: 14) {
                Button {
                    restartSession()
                } label: {
                    Text("再玩一次")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .cornerRadius(22)
                        .shadow(radius: 6)
                }
                .buttonStyle(BounceButtonStyle())

                Button {
                    speechService.stopSpeaking()
                    viewModel.recordActivity(stars: 1)
                    viewModel.exitSoundMatch()
                } label: {
                    Text("回到注音選單")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(22)
                }
                .buttonStyle(BounceButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Game Logic
    private func setupRound() {
        // 從37個字中選4個，其中一個是目標
        let pool = BopomofoConstants.allCharacters.shuffled()
        let four = Array(pool.prefix(4))
        choices = four.shuffled()
        targetCharacter = four.randomElement()!

        wrongChoice = nil
        correctChoice = nil
        isReadyForNext = false

        // 自動播放聲音
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            playCurrentSound()
        }
    }

    private func playCurrentSound() {
        speechService.speak(targetCharacter)
    }

    private func handleChoice(_ char: String) {
        guard correctChoice == nil else { return }

        if char == targetCharacter {
            // 答對
            correctChoice = char
            correctCount += 1
            audioService.playTapSound()
            audioService.playHaptic()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                advanceRound()
            }
        } else {
            // 答錯 — 搖晃動畫，可再試
            wrongChoice = char
            audioService.playHaptic()

            // 搖晃動畫
            withAnimation(.default) {
                shakeOffset = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.default) { shakeOffset = -10 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                withAnimation(.default) { shakeOffset = 8 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                withAnimation(.default) { shakeOffset = 0 }
            }

            // 清除錯誤狀態，讓用戶再試
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                wrongChoice = nil
            }

            // 再次播放正確聲音提示
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                playCurrentSound()
            }
        }
    }

    private func advanceRound() {
        if round >= totalRounds {
            phase = .sessionComplete
        } else {
            round += 1
            setupRound()
        }
    }

    private func restartSession() {
        round = 1
        correctCount = 0
        phase = .playing
        setupRound()
    }
}
