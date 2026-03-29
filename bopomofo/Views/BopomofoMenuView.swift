import SwiftUI

struct BopomofoMenuView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showSettings = false

    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.6, blue: 1.0),
                    Color(red: 0.55, green: 0.35, blue: 1.0),
                    Color(red: 0.9, green: 0.3, blue: 0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // ── 頂部導航列 ─────────────────────────────
                HStack {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            viewModel.enterHub()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "house.fill")
                            Text("主頁")
                        }
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(20)
                    }

                    Spacer()

                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.25))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 4)

                // ── 標題區 ─────────────────────────────────
                VStack(spacing: 6) {
                    Text("📝 注音 BoPoMoFo")
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 6)

                    Text("選擇你的學習活動")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.vertical, 20)

                // ── 最高分顯示 ────────────────────────────
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("最高分")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(viewModel.highScore)")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.white)
                    }

                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 1, height: 40)

                    VStack(spacing: 4) {
                        Text("星星")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        HStack(spacing: 4) {
                            Text("⭐")
                                .font(.system(size: 22))
                            Text("\(viewModel.userProgress.totalStars)")
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 36)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)

                // ── 活動按鈕 ──────────────────────────────
                VStack(spacing: 14) {
                    activityButton(
                        emoji: "🎮",
                        title: "掉落遊戲",
                        subtitle: "用虛擬鍵盤消除掉落的注音",
                        gradient: [Color(red: 1.0, green: 0.4, blue: 0.3),
                                   Color(red: 1.0, green: 0.6, blue: 0.1)]
                    ) {
                        viewModel.startGame()
                    }

                    activityButton(
                        emoji: "📚",
                        title: "學習卡片",
                        subtitle: "點擊卡片聽注音發音",
                        gradient: [Color(red: 0.1, green: 0.75, blue: 0.5),
                                   Color(red: 0.1, green: 0.9, blue: 0.7)]
                    ) {
                        viewModel.enterLearningMode()
                    }

                    activityButton(
                        emoji: "🔊",
                        title: "聽音辨字",
                        subtitle: "聽聲音，選出正確的注音",
                        gradient: [Color(red: 0.9, green: 0.4, blue: 0.9),
                                   Color(red: 0.6, green: 0.2, blue: 1.0)]
                    ) {
                        viewModel.enterSoundMatch()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
    }

    // MARK: - Activity Button
    @ViewBuilder
    private func activityButton(
        emoji: String,
        title: String,
        subtitle: String,
        gradient: [Color],
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 40))
                    .frame(width: 60, height: 60)
                    .background(Color.white.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(20)
            .shadow(color: gradient.first?.opacity(0.35) ?? .clear, radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
        }
        .buttonStyle(BounceButtonStyle())
    }
}
