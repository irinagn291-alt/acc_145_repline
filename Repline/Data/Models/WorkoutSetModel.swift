import Foundation
import SwiftData

/// SwiftData persistence model mirroring the `WorkoutSet` domain entity — one floor of the tower.
@Model
final class WorkoutSetModel {
    @Attribute(.unique) var id: UUID
    var exerciseName: String
    var weight: Double
    var reps: Int
    var date: Date
    var isPersonalRecord: Bool

    var workout: WorkoutModel?

    init(id: UUID, exerciseName: String, weight: Double, reps: Int, date: Date, isPersonalRecord: Bool, workout: WorkoutModel? = nil) {
        self.id = id
        self.exerciseName = exerciseName
        self.weight = weight
        self.reps = reps
        self.date = date
        self.isPersonalRecord = isPersonalRecord
        self.workout = workout
    }
}

extension WorkoutSetModel {
    convenience init(set: WorkoutSet) {
        self.init(
            id: set.id,
            exerciseName: set.exerciseName,
            weight: set.weight,
            reps: set.reps,
            date: set.date,
            isPersonalRecord: set.isPersonalRecord
        )
    }

    func toDomain() -> WorkoutSet {
        WorkoutSet(
            id: id,
            workoutID: workout?.id ?? UUID(),
            exerciseName: exerciseName,
            weight: weight,
            reps: reps,
            date: date,
            isPersonalRecord: isPersonalRecord
        )
    }
}
