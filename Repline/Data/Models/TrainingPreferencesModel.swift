import Foundation
import SwiftData

/// SwiftData persistence model mirroring `TrainingPreferences`. A single row acts as a singleton.
@Model
final class TrainingPreferencesModel {
    @Attribute(.unique) var id: UUID
    var goalRawValue: String
    var experienceRawValue: String
    /// Comma-separated `Weekday.rawValue`s.
    var trainingDaysRawValue: String

    init(id: UUID, goalRawValue: String, experienceRawValue: String, trainingDaysRawValue: String) {
        self.id = id
        self.goalRawValue = goalRawValue
        self.experienceRawValue = experienceRawValue
        self.trainingDaysRawValue = trainingDaysRawValue
    }
}

extension TrainingPreferencesModel {
    convenience init(preferences: TrainingPreferences) {
        let daysString = preferences.trainingDays.map { String($0.rawValue) }.joined(separator: ",")
        self.init(
            id: UUID(),
            goalRawValue: preferences.goal.rawValue,
            experienceRawValue: preferences.experience.rawValue,
            trainingDaysRawValue: daysString
        )
    }

    func toDomain() -> TrainingPreferences? {
        guard let goal = TrainingGoal(rawValue: goalRawValue), let experience = ExperienceLevel(rawValue: experienceRawValue) else {
            return nil
        }
        let days = Set(
            trainingDaysRawValue
                .split(separator: ",")
                .compactMap { Int($0) }
                .compactMap { Weekday(rawValue: $0) }
        )
        return TrainingPreferences(goal: goal, experience: experience, trainingDays: days)
    }
}
