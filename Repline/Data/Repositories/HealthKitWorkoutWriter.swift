import Foundation
import HealthKit

/// Writes completed workouts to Apple Health as strength-training sessions.
/// Gracefully no-ops whenever HealthKit data is unavailable on the device or access is denied —
/// Repline never blocks core functionality on Health access.
final class HealthKitWorkoutWriter: HealthWorkoutWriting {
    private let healthStore: HKHealthStore?

    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

    init() {
        healthStore = HKHealthStore.isHealthDataAvailable() ? HKHealthStore() : nil
    }

    func requestAuthorizationIfNeeded() async -> Bool {
        guard let healthStore else { return false }
        guard let workoutType = HKObjectType.workoutType() as HKSampleType? else { return false }
        do {
            try await healthStore.requestAuthorization(toShare: [workoutType], read: [])
            return true
        } catch {
            return false
        }
    }

    func writeWorkout(_ workout: Workout) async {
        guard let healthStore, !workout.sets.isEmpty else { return }

        let start = workout.sets.map(\.date).min() ?? workout.date
        let end = workout.sets.map(\.date).max() ?? workout.date
        let totalEnergy = HKQuantity(unit: .kilocalorie(), doubleValue: workout.totalTonnage * 0.05)

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining

        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())

        do {
            try await builder.beginCollection(at: start)
            let energySample = HKQuantitySample(
                type: HKQuantityType(.activeEnergyBurned),
                quantity: totalEnergy,
                start: start,
                end: end
            )
            try await builder.addSamples([energySample])
            try await builder.endCollection(at: end)
            _ = try await builder.finishWorkout()
        } catch {
            // Health-sync is a best-effort enhancement; failures never surface to the user.
        }
    }
}
