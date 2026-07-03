import Foundation
import SwiftData

/// Concrete `PersonalRecordRepository` backed by a SwiftData `ModelContext`.
@MainActor
final class SwiftDataPersonalRecordRepository: PersonalRecordRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [PersonalRecord] {
        let descriptor = FetchDescriptor<PersonalRecordModel>(sortBy: [SortDescriptor(\.achievedDate, order: .reverse)])
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func fetchRecord(forExercise exerciseName: String) async throws -> PersonalRecord? {
        let descriptor = FetchDescriptor<PersonalRecordModel>(predicate: #Predicate { $0.exerciseName == exerciseName })
        return try modelContext.fetch(descriptor).first?.toDomain()
    }

    func upsert(_ record: PersonalRecord) async throws {
        let exerciseName = record.exerciseName
        let descriptor = FetchDescriptor<PersonalRecordModel>(predicate: #Predicate { $0.exerciseName == exerciseName })
        if let existing = try modelContext.fetch(descriptor).first {
            existing.bestWeight = record.bestWeight
            existing.bestReps = record.bestReps
            existing.estimatedOneRepMax = record.estimatedOneRepMax
            existing.achievedDate = record.achievedDate
            existing.achievedSetID = record.achievedSetID
        } else {
            modelContext.insert(PersonalRecordModel(record: record))
        }
        try modelContext.save()
    }

    func deleteAll() async throws {
        try modelContext.delete(model: PersonalRecordModel.self)
        try modelContext.save()
    }
}
