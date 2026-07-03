import Foundation

/// Backs the settings screen: appearance, Health-sync, notifications, export, and reset.
@MainActor
@Observable
final class SettingsViewModel {
    private(set) var isHealthAvailable: Bool
    private(set) var isExporting = false
    private(set) var exportedCSV: String?
    private(set) var didReset = false

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        isHealthAvailable = dependencies.healthWriter.isAvailable
    }

    func handleHealthSyncToggle(isEnabled: Bool) async -> Bool {
        guard isEnabled else { return false }
        guard isHealthAvailable else { return false }
        return await dependencies.healthWriter.requestAuthorizationIfNeeded()
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
