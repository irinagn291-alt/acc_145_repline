import Foundation

/// Today's "floor of the day" volume goal and progress towards it.
struct DailyFloorGoal: Equatable, Sendable {
    let targetTonnage: Double
    let loggedTonnage: Double

    var progress: Double {
        guard targetTonnage > 0 else { return 0 }
        return min(1, loggedTonnage / targetTonnage)
    }

    var isComplete: Bool { loggedTonnage >= targetTonnage }
}
