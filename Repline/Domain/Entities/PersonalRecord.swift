import Foundation

/// The best-known performance for a given exercise, used to auto-detect new PRs.
struct PersonalRecord: Identifiable, Equatable, Sendable {
    let id: UUID
    let exerciseName: String
    let bestWeight: Double
    let bestReps: Int
    let estimatedOneRepMax: Double
    let achievedDate: Date
    let achievedSetID: UUID

    init(
        id: UUID = UUID(),
        exerciseName: String,
        bestWeight: Double,
        bestReps: Int,
        estimatedOneRepMax: Double,
        achievedDate: Date,
        achievedSetID: UUID
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.bestWeight = bestWeight
        self.bestReps = bestReps
        self.estimatedOneRepMax = estimatedOneRepMax
        self.achievedDate = achievedDate
        self.achievedSetID = achievedSetID
    }
}
