import SwiftUI

/// Reusable streak display component shown in the hub top bar.
struct StreakBadgeView: View {
    let streak: Int
    var celebrate: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Text("🔥")
                .font(.system(size: 22))
            Text("\(streak)")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(streak > 0 ? .orange : .gray)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(streak > 0
                      ? Color.orange.opacity(0.15)
                      : Color.gray.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(streak > 0 ? Color.orange.opacity(0.5) : Color.gray.opacity(0.3),
                        lineWidth: 2)
        )
        .scaleEffect(celebrate ? 1.25 : 1.0)
        .animation(
            celebrate
                ? .spring(response: 0.3, dampingFraction: 0.4).repeatCount(3, autoreverses: true)
                : .default,
            value: celebrate
        )
    }
}

/// Star / XP display badge for the hub top bar.
struct StarBadgeView: View {
    let totalStars: Int
    let level: Int

    var body: some View {
        HStack(spacing: 4) {
            Text("⭐")
                .font(.system(size: 22))
            VStack(alignment: .leading, spacing: 0) {
                Text("\(totalStars)")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.yellow)
                Text("Lv.\(level)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.yellow.opacity(0.8))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
        )
    }
}
