import SwiftUI
import Combine

struct HubView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showSettings = false
    @State private var mascotMessageIndex = 0
    @State private var mascotBounce = false

    private let mascotMessages = [
        "你好棒！",
        "加油！",
        "今天也要努力喔！",
        "我們一起學習吧！"
    ]

    private let messageTimer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // 背景漸層 — 溫暖、活潑
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.55, blue: 0.0),  // 橙
                    Color(red: 1.0, green: 0.8,  blue: 0.0),  // 黃
                    Color(red: 0.4, green: 0.85, blue: 0.55)   // 綠
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // ── 頂部工具列 ──────────────────────────
                topBar

                // ── 吉祥物 ──────────────────────────────
                mascotArea
                    .padding(.top, 10)

                // ── 模組卡片 ────────────────────────────
                VStack(spacing: 16) {
                    moduleCard(
                        emoji: "📝",
                        title: "注音 BoPoMoFo",
                        subtitle: "認識37個注音符號",
                        gradient: [Color(red: 0.2, green: 0.6, blue: 1.0),
                                   Color(red: 0.55, green: 0.35, blue: 1.0)],
                        locked: false
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            viewModel.enterBopomofoMenu()
                        }
                    }

                    moduleCard(
                        emoji: "📖",
                        title: "國字 Characters",
                        subtitle: "敬請期待",
                        gradient: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
                        locked: true,
                        badge: "敬請期待"
                    ) {}

                    moduleCard(
                        emoji: "🔢",
                        title: "數學 Math",
                        subtitle: "敬請期待",
                        gradient: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
                        locked: true,
                        badge: "敬請期待"
                    ) {}
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()
            }

            // ── 連勝慶祝特效 ────────────────────────────
            if viewModel.showStreakCelebration {
                StreakCelebrationView()
                    .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
        .onReceive(messageTimer) { _ in
            withAnimation(.easeInOut(duration: 0.4)) {
                mascotMessageIndex = (mascotMessageIndex + 1) % mascotMessages.count
            }
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack(spacing: 12) {
            StreakBadgeView(
                streak: viewModel.userProgress.currentStreak,
                celebrate: viewModel.showStreakCelebration
            )

            StarBadgeView(
                totalStars: viewModel.userProgress.totalStars,
                level: viewModel.userProgress.level
            )

            Spacer()

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.25))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Mascot
    private var mascotArea: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // 吉祥物 SF Symbol (Allen 之後替換成 3D 角色)
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 72, height: 72)
                Image(systemName: "face.smiling")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                    .foregroundColor(.white)
            }
            .scaleEffect(mascotBounce ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: mascotBounce)
            .onTapGesture {
                mascotBounce = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    mascotBounce = false
                }
            }

            // 對話泡泡
            Text(mascotMessages[mascotMessageIndex])
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.92))
                        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                )
                .overlay(
                    // 泡泡尖角
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.white.opacity(0.92))
                        .font(.system(size: 14))
                        .offset(x: -18, y: 0),
                    alignment: .leading
                )
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .id(mascotMessageIndex)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    // MARK: - Module Card
    @ViewBuilder
    private func moduleCard(
        emoji: String,
        title: String,
        subtitle: String,
        gradient: [Color],
        locked: Bool,
        badge: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 44))
                    .frame(width: 64, height: 64)
                    .background(Color.white.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                } else {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(22)
            .shadow(color: gradient.first?.opacity(0.4) ?? .clear, radius: 8, x: 0, y: 4)
            .opacity(locked ? 0.6 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
        }
        .disabled(locked)
        .buttonStyle(BounceButtonStyle())
    }
}

// MARK: - Bounce Button Style
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Streak Celebration Overlay
struct StreakCelebrationView: View {
    @State private var particles: [CelebrationParticle] = []
    @State private var appeared = false

    var body: some View {
        ZStack {
            ForEach(particles) { p in
                Text(p.symbol)
                    .font(.system(size: p.size))
                    .position(x: p.x, y: appeared ? p.endY : p.startY)
                    .opacity(appeared ? 0 : 1)
                    .animation(
                        .easeOut(duration: p.duration).delay(p.delay),
                        value: appeared
                    )
            }

            // 中央提示
            VStack(spacing: 8) {
                Text("🔥")
                    .font(.system(size: 60))
                    .scaleEffect(appeared ? 1.0 : 0.5)
                    .opacity(appeared ? 0 : 1)
                    .animation(.spring(response: 0.4, dampingFraction: 0.5), value: appeared)
                Text("連勝增加！")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .opacity(appeared ? 0 : 1)
                    .animation(.easeOut(duration: 1.5).delay(0.5), value: appeared)
            }
        }
        .onAppear {
            particles = (0..<18).map { _ in CelebrationParticle() }
            withAnimation {
                appeared = true
            }
        }
    }
}

private struct CelebrationParticle: Identifiable {
    let id = UUID()
    let symbol: String
    let x: CGFloat
    let startY: CGFloat
    let endY: CGFloat
    let size: CGFloat
    let duration: Double
    let delay: Double

    init() {
        let symbols = ["⭐", "🌟", "✨", "🎉", "🎊", "💫"]
        symbol = symbols.randomElement()!
        x = CGFloat.random(in: 40...340)
        startY = CGFloat.random(in: 200...500)
        endY = startY - CGFloat.random(in: 150...300)
        size = CGFloat.random(in: 20...40)
        duration = Double.random(in: 1.2...2.0)
        delay = Double.random(in: 0...0.6)
    }
}
