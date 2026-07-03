import Foundation
import UserNotifications

/// Schedules local workout-day reminders via `UNUserNotificationCenter`. Never uses push/OneSignal.
@MainActor
final class LocalWorkoutReminderScheduler: WorkoutReminderScheduling {
    private let center: UNUserNotificationCenter
    private let reminderIdentifierPrefix = "repline.reminder.weekday."
    /// 18:00 local time — after a typical work/school day, ahead of an evening session.
    private let reminderHour = 18
    private let reminderMinute = 0

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorizationIfNeeded() async -> Bool {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return true
        case .notDetermined:
            do {
                return try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                return false
            }
        default:
            return false
        }
    }

    func scheduleReminders(for days: Set<Weekday>) async {
        await cancelAllReminders()

        for day in days {
            var dateComponents = DateComponents()
            // `DateComponents.weekday` uses Calendar's 1 = Sunday ordering.
            dateComponents.weekday = day == .sunday ? 1 : day.rawValue + 1
            dateComponents.hour = reminderHour
            dateComponents.minute = reminderMinute

            let content = UNMutableNotificationContent()
            content.title = "Repline"
            content.body = "The tower awaits a new floor. Leg day today — let's go."
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: reminderIdentifierPrefix + "\(day.rawValue)", content: content, trigger: trigger)
            try? await center.add(request)
        }
    }

    func cancelAllReminders() async {
        let identifiers = Weekday.allCases.map { reminderIdentifierPrefix + "\($0.rawValue)" }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
