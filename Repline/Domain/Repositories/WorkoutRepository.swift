import Foundation

/// Abstracts persistence for workouts and their sets away from any storage technology.
protocol WorkoutRepository {
    func fetchAll() async throws -> [Workout]
    func fetchWorkout(id: UUID) async throws -> Workout?
    func fetchWorkout(on day: Date) async throws -> Workout?
    /// Creates the workout if needed, appends the set, and returns the updated workout.
    func appendSet(_ set: WorkoutSet, programType: ProgramType?, to day: Date) async throws -> Workout
    func deleteWorkout(id: UUID) async throws
    func deleteAll() async throws
}
