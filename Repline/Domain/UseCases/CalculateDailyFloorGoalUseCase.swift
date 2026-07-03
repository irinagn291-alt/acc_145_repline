import Foundation

/// Derives today's "floor of the day" tonnage goal from the user's experience level and
/// measures progress against the tonnage already logged today.
protocol CalculateDailyFloorGoalUseCase {
    func execute(workouts: [Workout], preferences: TrainingPreferences, day: Date, calendar: Calendar) -> DailyFloorGoal
}

final class DefaultCalculateDailyFloorGoalUseCase: CalculateDailyFloorGoalUseCase {
    func execute(workouts: [Workout], preferences: TrainingPreferences, day: Date, calendar: Calendar = .current) -> DailyFloorGoal {
        let loggedToday = workouts
            .filter { calendar.isDate($0.date, inSameDayAs: day) }
            .reduce(0) { $0 + $1.totalTonnage }

        let goalMultiplier: Double
        switch preferences.goal {
        case .strength: goalMultiplier = 1.1
        case .mass: goalMultiplier = 1.0
        case .tone: goalMultiplier = 0.75
        }

        let target = preferences.experience.baselineDailyTonnage * goalMultiplier
        return DailyFloorGoal(targetTonnage: target, loggedTonnage: loggedToday)
    }
}
