import Foundation

/// A single logged set: one exercise, one weight x reps pair — one "floor" of the tower.
struct WorkoutSet: Identifiable, Equatable, Sendable {
    let id: UUID
    let workoutID: UUID
    let exerciseName: String
    /// Weight in kilograms.
    let weight: Double
    let reps: Int
    let date: Date
    let isPersonalRecord: Bool

    init(
        id: UUID = UUID(),
        workoutID: UUID,
        exerciseName: String,
        weight: Double,
        reps: Int,
        date: Date = .now,
        isPersonalRecord: Bool = false
    ) {
        self.id = id
        self.workoutID = workoutID
        self.exerciseName = exerciseName
        self.weight = weight
        self.reps = reps
        self.date = date
        self.isPersonalRecord = isPersonalRecord
    }

    /// Tonnage contributed by this single set (weight x reps).
    var tonnage: Double { weight * Double(reps) }

    /// Epley-formula estimated one-rep max, used to compare PR-worthiness across rep ranges.
    var estimatedOneRepMax: Double { weight * (1.0 + Double(reps) / 30.0) }

    func markedAsPersonalRecord() -> WorkoutSet {
        WorkoutSet(
            id: id,
            workoutID: workoutID,
            exerciseName: exerciseName,
            weight: weight,
            reps: reps,
            date: date,
            isPersonalRecord: true
        )
    }
}
