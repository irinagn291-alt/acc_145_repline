import Foundation

/// Backs the settings screen: appearance, notifications, export, and reset.
@MainActor
@Observable
final class SettingsViewModel {
    private(set) var isExporting = false
    private(set) var exportedCSV: String?
    private(set) var didReset = false

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func handleNotificationsToggle(isEnabled: Bool, trainingDays: Set<Weekday>) async {
        if isEnabled {
            await dependencies.scheduleWorkoutReminders.execute(for: trainingDays)
        } else {
            await dependencies.reminderScheduler.cancelAllReminders()
        }
    }

    func exportHistory() async {
        isExporting = true
        defer { isExporting = false }
        let workouts = try? await dependencies.fetchWorkoutHistory.execute()
        exportedCSV = dependencies.exportWorkoutHistory.execute(workouts ?? [])
    }

    func resetAllData() async {
        try? await dependencies.resetAllData.execute()
        didReset = true
    }
}
