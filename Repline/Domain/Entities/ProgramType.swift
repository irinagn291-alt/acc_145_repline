import Foundation

/// A push/pull/legs style program template that pre-fills suggested exercises.
enum ProgramType: String, CaseIterable, Identifiable, Codable, Sendable {
    case push
    case pull
    case legs

    var id: String { rawValue }

    var title: String {
        switch self {
        case .push: return "Push"
        case .pull: return "Pull"
        case .legs: return "Legs"
        }
    }

    var subtitle: String {
        switch self {
        case .push: return "Chest, shoulders, triceps"
        case .pull: return "Back, biceps"
        case .legs: return "Legs, glutes"
        }
    }

    var symbolName: String {
        switch self {
        case .push: return "arrow.up.circle.fill"
        case .pull: return "arrow.down.circle.fill"
        case .legs: return "figure.walk.circle.fill"
        }
    }

    /// Suggested exercise names shown as quick-fill chips when logging a set.
    var suggestedExercises: [String] {
        switch self {
        case .push: return ["Bench Press", "Dumbbell Shoulder Press", "Tricep Pushdown"]
        case .pull: return ["Barbell Row", "Lat Pulldown", "Bicep Curl"]
        case .legs: return ["Barbell Squat", "Leg Press", "Calf Raise"]
        }
    }
}
