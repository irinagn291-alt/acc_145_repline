import Foundation

/// Abstracts persistence for the onboarding-captured training preferences.
protocol TrainingPreferencesRepository {
    func fetch() async throws -> TrainingPreferences?
    func save(_ preferences: TrainingPreferences) async throws
    func deleteAll() async throws
}
