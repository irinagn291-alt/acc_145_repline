import Foundation

/// Renders the full workout history as a CSV string for sharing/export.
final class CSVWorkoutHistoryExporter: WorkoutHistoryExporting {
    private let dateFormatter: DateFormatter

    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter = formatter
    }

    func exportCSV(_ workouts: [Workout]) -> String {
        var lines = ["date,programType,exercise,weightKg,reps,tonnage,isPR"]
        for workout in workouts.sorted(by: { $0.date < $1.date }) {
            for set in workout.sets {
                let row = [
                    dateFormatter.string(from: set.date),
                    workout.programType?.rawValue ?? "",
                    set.exerciseName.replacingOccurrences(of: ",", with: ";"),
                    String(set.weight),
                    String(set.reps),
                    String(set.tonnage),
                    set.isPersonalRecord ? "true" : "false",
                ].joined(separator: ",")
                lines.append(row)
            }
        }
        return lines.joined(separator: "\n")
    }
}
