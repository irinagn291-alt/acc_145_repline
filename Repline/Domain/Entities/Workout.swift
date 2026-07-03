import Foundation

/// A training session (typically one calendar day) grouping the sets logged during it.
struct Workout: Identifiable, Equatable, Sendable {
    let id: UUID
    let date: Date
    let programType: ProgramType?
    let sets: [WorkoutSet]

    init(id: UUID = UUID(), date: Date = .now, programType: ProgramType? = nil, sets: [WorkoutSet] = []) {
        self.id = id
        self.date = date
        self.programType = programType
        self.sets = sets
    }

    /// Total tonnage (weight x reps, summed) logged in this session.
    var totalTonnage: Double { sets.reduce(0) { $0 + $1.tonnage } }

    var personalRecordCount: Int { sets.filter(\.isPersonalRecord).count }
}
