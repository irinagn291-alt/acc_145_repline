import Foundation
import SwiftData

/// Lightweight dependency container: wires repositories and use cases against a shared
/// `ModelContext`. Passed explicitly through initializers — never accessed as a singleton.
@MainActor
final class AppDependencies {
    let haptics = HapticsService()
    let healthWriter: HealthWorkoutWriting
    let reminderScheduler: WorkoutReminderScheduling

    let logSet: LogSetUseCase
    let calculateTowerHeight: CalculateTowerHeightUseCase
    let fetchWorkoutHistory: FetchWorkoutHistoryUseCase
    let fetchPersonalRecords: FetchPersonalRecordsUseCase
    let calculateDailyFloorGoal: CalculateDailyFloorGoalUseCase
    let fetchVolumeAnalytics: FetchVolumeAnalyticsUseCase
    let saveTrainingPreferences: SaveTrainingPreferencesUseCase
    let fetchTrainingPreferences: FetchTrainingPreferencesUseCase
    let scheduleWorkoutReminders: ScheduleWorkoutRemindersUseCase
    let syncWorkoutToHealth: SyncWorkoutToHealthUseCase
    let exportWorkoutHistory: ExportWorkoutHistoryUseCase
    let resetAllData: ResetAllDataUseCase

    init(modelContext: ModelContext) {
        let workoutRepository = SwiftDataWorkoutRepository(modelContext: modelContext)
        let personalRecordRepository = SwiftDataPersonalRecordRepository(modelContext: modelContext)
        let preferencesRepository = SwiftDataTrainingPreferencesRepository(modelContext: modelContext)
        let healthWriter = HealthKitWorkoutWriter()
        let reminderScheduler = LocalWorkoutReminderScheduler()
        let historyExporter = CSVWorkoutHistoryExporter()
        self.healthWriter = healthWriter
        self.reminderScheduler = reminderScheduler

        logSet = DefaultLogSetUseCase(workouts: workoutRepository, personalRecords: personalRecordRepository)
        calculateTowerHeight = DefaultCalculateTowerHeightUseCase()
        fetchWorkoutHistory = DefaultFetchWorkoutHistoryUseCase(workouts: workoutRepository)
        fetchPersonalRecords = DefaultFetchPersonalRecordsUseCase(personalRecords: personalRecordRepository)
        calculateDailyFloorGoal = DefaultCalculateDailyFloorGoalUseCase()
        fetchVolumeAnalytics = DefaultFetchVolumeAnalyticsUseCase()
        saveTrainingPreferences = DefaultSaveTrainingPreferencesUseCase(repository: preferencesRepository)
        fetchTrainingPreferences = DefaultFetchTrainingPreferencesUseCase(repository: preferencesRepository)
        scheduleWorkoutReminders = DefaultScheduleWorkoutRemindersUseCase(scheduler: reminderScheduler)
        syncWorkoutToHealth = DefaultSyncWorkoutToHealthUseCase(healthWriter: healthWriter)
        exportWorkoutHistory = DefaultExportWorkoutHistoryUseCase(exporter: historyExporter)
        resetAllData = DefaultResetAllDataUseCase(
            workouts: workoutRepository,
            personalRecords: personalRecordRepository,
            preferences: preferencesRepository,
            reminderScheduler: reminderScheduler
        )
    }
}
