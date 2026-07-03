import Foundation

/// The user's primary training goal, selected during onboarding.
enum TrainingGoal: String, CaseIterable, Identifiable, Codable, Sendable {
    case strength
    case mass
    case tone

    var id: String { rawValue }

    var title: String {
        switch self {
        case .strength: return "Strength"
        case .mass: return "Mass"
        case .tone: return "Tone"
        }
    }

    var subtitle: String {
        switch self {
        case .strength: return "Lift heavier weights"
        case .mass: return "Build muscle volume"
        case .tone: return "Stay lean and conditioned"
        }
    }

    var symbolName: String {
        switch self {
        case .strength: return "bolt.fill"
        case .mass: return "figure.strengthtraining.traditional"
        case .tone: return "figure.mixed.cardio"
        }
    }
}
