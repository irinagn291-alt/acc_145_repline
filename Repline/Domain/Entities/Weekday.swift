import Foundation

/// ISO-8601 style weekday (1 = Monday ... 7 = Sunday), used for training-day selection and reminders.
enum Weekday: Int, CaseIterable, Identifiable, Codable, Sendable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: Int { rawValue }

    var shortTitle: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }

    /// Maps from `Calendar` weekday component (1 = Sunday ... 7 = Saturday) to this ISO-ordered enum.
    static func fromCalendarComponent(_ value: Int) -> Weekday {
        Weekday(rawValue: value == 1 ? 7 : value - 1) ?? .monday
    }
}
