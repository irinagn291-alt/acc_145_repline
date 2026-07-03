import Foundation

/// Abstracts writing completed strength-training sessions to Apple Health.
/// Implementations must no-op gracefully when HealthKit is unavailable or access is denied.
protocol HealthWorkoutWriting {
    var isAvailable: Bool { get }
    func requestAuthorizationIfNeeded() async -> Bool
    func writeWorkout(_ workout: Workout) async
}
