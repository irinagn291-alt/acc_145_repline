import Foundation

/// Outcome of logging a single set: the new floor, its workout, and whether it broke a PR.
struct LoggedSetOutcome: Equatable, Sendable {
    let set: WorkoutSet
    let workout: Workout
    let isNewPersonalRecord: Bool
}

/// Logs a new set, grouping it into the day's workout, and auto-detects whether it is a new
/// personal record by comparing its estimated one-rep max against the stored best for that exercise.
protocol LogSetUseCase {
    func execute(exerciseName: String, weight: Double, reps: Int, programType: ProgramType?, day: Date) async throws -> LoggedSetOutcome
}

final class DefaultLogSetUseCase: LogSetUseCase {
    private let workouts: WorkoutRepository
    private let personalRecords: PersonalRecordRepository

    init(workouts: WorkoutRepository, personalRecords: PersonalRecordRepository) {
        self.workouts = workouts
        self.personalRecords = personalRecords
    }

    func execute(exerciseName: String, weight: Double, reps: Int, programType: ProgramType?, day: Date) async throws -> LoggedSetOutcome {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        let candidate = WorkoutSet(workoutID: UUID(), exerciseName: trimmedName, weight: weight, reps: reps, date: day)

        let existingRecord = try await personalRecords.fetchRecord(forExercise: trimmedName)
        let isNewRecord = existingRecord == nil || candidate.estimatedOneRepMax > existingRecord!.estimatedOneRepMax

        let finalSet = isNewRecord ? candidate.markedAsPersonalRecord() : candidate
        let workout = try await workouts.appendSet(finalSet, programType: programType, to: day)

        if isNewRecord {
            let record = PersonalRecord(
                exerciseName: trimmedName,
                bestWeight: weight,
                bestReps: reps,
                estimatedOneRepMax: finalSet.estimatedOneRepMax,
                achievedDate: day,
                achievedSetID: finalSet.id
            )
            try await personalRecords.upsert(record)
        }

        return LoggedSetOutcome(set: finalSet, workout: workout, isNewPersonalRecord: isNewRecord)
    }
}
