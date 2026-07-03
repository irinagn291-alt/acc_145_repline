import Foundation

/// Abstracts local-notification scheduling for workout-day reminders.
/// Backed exclusively by `UNUserNotificationCenter` — never a push SDK.
@MainActor
protocol WorkoutReminderScheduling {
    func requestAuthorizationIfNeeded() async -> Bool
    func scheduleReminders(for days: Set<Weekday>) async
    func cancelAllReminders() async
}
