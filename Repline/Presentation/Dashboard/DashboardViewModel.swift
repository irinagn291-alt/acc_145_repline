import Foundation

/// Loads workout history and derives the volume/PR analytics shown on the dashboard.
@MainActor
@Observable
final class DashboardViewModel {
    private(set) var volumeSeries: [VolumeDataPoint] = []
    private(set) var personalRecords: [PersonalRecord] = []
    private(set) var towerHeight: TowerHeight = .zero
    private(set) var analytics: DashboardAnalytics = .empty
    private(set) var isLoading = false

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var totalWorkoutDays: Int { volumeSeries.count }
    var unlockedMilestones: [Milestone] { analytics.milestones }
    var lockedMilestones: [Milestone] {
        Milestone.allCases.filter { !analytics.milestones.contains($0) }
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let workouts = try await dependencies.fetchWorkoutHistory.execute()
            volumeSeries = dependencies.fetchVolumeAnalytics.execute(workouts: workouts)
            personalRecords = try await dependencies.fetchPersonalRecords.execute()
            towerHeight = dependencies.calculateTowerHeight.execute(workouts: workouts)
            analytics = DashboardAnalyticsBuilder.build(
                workouts: workouts,
                personalRecords: personalRecords,
                towerHeight: towerHeight
            )
        } catch {
            volumeSeries = []
            personalRecords = []
            analytics = .empty
        }
    }
}
