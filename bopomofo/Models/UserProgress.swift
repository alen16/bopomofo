import Foundation

struct UserProgress: Codable {
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActiveDate: Date? = nil
    var totalStars: Int = 0

    var level: Int {
        return (totalStars / 20) + 1
    }

    /// Update streak and add stars after completing an activity.
    /// Returns true if the streak increased (so the caller can show a celebration).
    mutating func recordActivity(stars: Int) -> Bool {
        totalStars += stars

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let last = lastActiveDate else {
            // First-ever activity
            currentStreak = 1
            longestStreak = max(longestStreak, currentStreak)
            lastActiveDate = today
            return true
        }

        let lastDay = calendar.startOfDay(for: last)

        if lastDay == today {
            // Already recorded today — streak unchanged
            return false
        }

        let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

        if daysBetween == 1 {
            // Consecutive day
            currentStreak += 1
            longestStreak = max(longestStreak, currentStreak)
            lastActiveDate = today
            return true
        } else {
            // Streak broken
            currentStreak = 1
            lastActiveDate = today
            return false
        }
    }
}
