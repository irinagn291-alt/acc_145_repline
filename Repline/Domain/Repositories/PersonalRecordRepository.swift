import Foundation

/// Abstracts persistence for the best-known performance per exercise.
protocol PersonalRecordRepository {
    func fetchAll() async throws -> [PersonalRecord]
    func fetchRecord(forExercise exerciseName: String) async throws -> PersonalRecord?
    func upsert(_ record: PersonalRecord) async throws
    func deleteAll() async throws
}
