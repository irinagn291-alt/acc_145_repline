import Foundation

/// Exports the full workout history as CSV text — always free, per the spec's ethical limits.
protocol ExportWorkoutHistoryUseCase {
    func execute(_ workouts: [Workout]) -> String
}

final class DefaultExportWorkoutHistoryUseCase: ExportWorkoutHistoryUseCase {
    private let exporter: WorkoutHistoryExporting

    init(exporter: WorkoutHistoryExporting) {
        self.exporter = exporter
    }

    func execute(_ workouts: [Workout]) -> String {
        exporter.exportCSV(workouts)
    }
}
