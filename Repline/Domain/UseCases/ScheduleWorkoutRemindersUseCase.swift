import Foundation

/// Requests local-notification authorization (if needed) and schedules reminders on the
/// user's chosen training days. No-ops silently if permission is denied.
protocol ScheduleWorkoutRemindersUseCase {
    func execute(for days: Set<Weekday>) async
}

@MainActor
final class DefaultScheduleWorkoutRemindersUseCase: ScheduleWorkoutRemindersUseCase {
    private let scheduler: WorkoutReminderScheduling

    init(scheduler: WorkoutReminderScheduling) {
        self.scheduler = scheduler
    }

    func execute(for days: Set<Weekday>) async {
        let granted = await scheduler.requestAuthorizationIfNeeded()
        guard granted else { return }
        await scheduler.scheduleReminders(for: days)
    }
}
