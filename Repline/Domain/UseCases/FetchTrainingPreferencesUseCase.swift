import Foundation

/// Fetches saved training preferences, falling back to sensible defaults if onboarding never ran.
protocol FetchTrainingPreferencesUseCase {
    func execute() async throws -> TrainingPreferences
}

final class DefaultFetchTrainingPreferencesUseCase: FetchTrainingPreferencesUseCase {
    private let repository: TrainingPreferencesRepository

    init(repository: TrainingPreferencesRepository) {
        self.repository = repository
    }

    func execute() async throws -> TrainingPreferences {
        try await repository.fetch() ?? .default
    }
}
