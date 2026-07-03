import Foundation

/// Fetches the full workout history, newest first.
protocol FetchWorkoutHistoryUseCase {
    func execute() async throws -> [Workout]
}

final class DefaultFetchWorkoutHistoryUseCase: FetchWorkoutHistoryUseCase {
    private let workouts: WorkoutRepository

    init(workouts: WorkoutRepository) {
        self.workouts = workouts
    }

    func execute() async throws -> [Workout] {
        try await workouts.fetchAll().sorted { $0.date > $1.date }
    }
}
