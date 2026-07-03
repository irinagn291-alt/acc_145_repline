import Foundation

/// The user's self-reported training experience, selected during onboarding.
enum ExperienceLevel: String, CaseIterable, Identifiable, Codable, Sendable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }

    var subtitle: String {
        switch self {
        case .beginner: return "Less than a year of training"
        case .intermediate: return "1–3 years under the bar"
        case .advanced: return "3+ years, know my max"
        }
    }

    /// Baseline daily tonnage target (kg) used to derive the "floor of the day" goal.
    var baselineDailyTonnage: Double {
        switch self {
        case .beginner: return 1_500
        case .intermediate: return 3_000
        case .advanced: return 5_000
        }
    }
}
