import Foundation
import SwiftData

/// SwiftData persistence model mirroring the `Workout` domain entity.
@Model
final class WorkoutModel {
    @Attribute(.unique) var id: UUID
    var date: Date
    var programTypeRawValue: String?

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSetModel.workout)
    var sets: [WorkoutSetModel]?

    init(id: UUID, date: Date, programTypeRawValue: String?, sets: [WorkoutSetModel] = []) {
        self.id = id
        self.date = date
        self.programTypeRawValue = programTypeRawValue
        self.sets = sets
    }
}

extension WorkoutModel {
    func toDomain() -> Workout {
        let domainSets = (sets ?? []).map { $0.toDomain() }.sorted { $0.date < $1.date }
        let programType = programTypeRawValue.flatMap { ProgramType(rawValue: $0) }
        return Workout(id: id, date: date, programType: programType, sets: domainSets)
    }
}
