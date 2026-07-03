import Foundation

/// Persists the goal/experience/training-days choices captured at the end of onboarding.
protocol SaveTrainingPreferencesUseCase {
    func execute(_ preferences: TrainingPreferences) async throws
}

final class DefaultSaveTrainingPreferencesUseCase: SaveTrainingPreferencesUseCase {
    private let repository: TrainingPreferencesRepository

    init(repository: TrainingPreferencesRepository) {
        self.repository = repository
    }

    func execute(_ preferences: TrainingPreferences) async throws {
        try await repository.save(preferences)
    }
}
