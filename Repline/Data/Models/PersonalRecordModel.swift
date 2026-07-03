import Foundation
import SwiftData

/// SwiftData persistence model mirroring the `PersonalRecord` domain entity.
@Model
final class PersonalRecordModel {
    @Attribute(.unique) var id: UUID
    var exerciseName: String
    var bestWeight: Double
    var bestReps: Int
    var estimatedOneRepMax: Double
    var achievedDate: Date
    var achievedSetID: UUID

    init(id: UUID, exerciseName: String, bestWeight: Double, bestReps: Int, estimatedOneRepMax: Double, achievedDate: Date, achievedSetID: UUID) {
        self.id = id
        self.exerciseName = exerciseName
        self.bestWeight = bestWeight
        self.bestReps = bestReps
        self.estimatedOneRepMax = estimatedOneRepMax
        self.achievedDate = achievedDate
        self.achievedSetID = achievedSetID
    }
}

extension PersonalRecordModel {
    convenience init(record: PersonalRecord) {
        self.init(
            id: record.id,
            exerciseName: record.exerciseName,
            bestWeight: record.bestWeight,
            bestReps: record.bestReps,
            estimatedOneRepMax: record.estimatedOneRepMax,
            achievedDate: record.achievedDate,
            achievedSetID: record.achievedSetID
        )
    }

    func toDomain() -> PersonalRecord {
        PersonalRecord(
            id: id,
            exerciseName: exerciseName,
            bestWeight: bestWeight,
            bestReps: bestReps,
            estimatedOneRepMax: estimatedOneRepMax,
            achievedDate: achievedDate,
            achievedSetID: achievedSetID
        )
    }
}
