import SwiftUI

struct CardView: View {
    let card: BopomofoCard
    
    var body: some View {
        Text(card.character)
            .font(.system(size: 36, weight: .black))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
            .frame(width: BopomofoConstants.cardSize, height: BopomofoConstants.cardSize)
            .background(card.color)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.white.opacity(0.6), lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
            .rotationEffect(.degrees(card.rotation))
    }
}
