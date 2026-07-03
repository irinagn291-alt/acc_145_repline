import Foundation

/// Mirrors a completed workout into Apple Health, gracefully doing nothing when HealthKit
/// is unavailable, access was denied, or the user disabled Health-sync in settings.
protocol SyncWorkoutToHealthUseCase {
    func execute(_ workout: Workout, isEnabled: Bool) async
}

final class DefaultSyncWorkoutToHealthUseCase: SyncWorkoutToHealthUseCase {
    private let healthWriter: HealthWorkoutWriting

    init(healthWriter: HealthWorkoutWriting) {
        self.healthWriter = healthWriter
    }

    func execute(_ workout: Workout, isEnabled: Bool) async {
        guard isEnabled, healthWriter.isAvailable else { return }
        let authorized = await healthWriter.requestAuthorizationIfNeeded()
        guard authorized else { return }
        await healthWriter.writeWorkout(workout)
    }
}
