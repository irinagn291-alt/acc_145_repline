import Foundation

/// User-selected training preferences captured during onboarding, reused for daily goals and reminders.
struct TrainingPreferences: Equatable, Sendable {
    let goal: TrainingGoal
    let experience: ExperienceLevel
    let trainingDays: Set<Weekday>

    static let `default` = TrainingPreferences(goal: .strength, experience: .beginner, trainingDays: [.monday, .wednesday, .friday])

    init(goal: TrainingGoal, experience: ExperienceLevel, trainingDays: Set<Weekday>) {
        self.goal = goal
        self.experience = experience
        self.trainingDays = trainingDays
    }
}
