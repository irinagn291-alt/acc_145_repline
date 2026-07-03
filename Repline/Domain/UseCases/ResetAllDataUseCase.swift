import Foundation

/// Wipes all locally stored workouts, personal records and preferences, and cancels reminders.
@MainActor
protocol ResetAllDataUseCase {
    func execute() async throws
}

@MainActor
final class DefaultResetAllDataUseCase: ResetAllDataUseCase {
    private let workouts: WorkoutRepository
    private let personalRecords: PersonalRecordRepository
    private let preferences: TrainingPreferencesRepository
    private let reminderScheduler: WorkoutReminderScheduling

    init(
        workouts: WorkoutRepository,
        personalRecords: PersonalRecordRepository,
        preferences: TrainingPreferencesRepository,
        reminderScheduler: WorkoutReminderScheduling
    ) {
        self.workouts = workouts
        self.personalRecords = personalRecords
        self.preferences = preferences
        self.reminderScheduler = reminderScheduler
    }

    func execute() async throws {
        try await workouts.deleteAll()
        try await personalRecords.deleteAll()
        try await preferences.deleteAll()
        await reminderScheduler.cancelAllReminders()
    }
}
