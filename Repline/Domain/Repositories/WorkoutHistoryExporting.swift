import Foundation

/// Abstracts exporting the full workout history to a shareable format.
protocol WorkoutHistoryExporting {
    /// Returns CSV text covering every logged set (free and exportable, per spec).
    func exportCSV(_ workouts: [Workout]) -> String
}
