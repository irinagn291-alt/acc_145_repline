import Foundation

/// Aggregated analytics derived from workout history for the dashboard.
struct DashboardAnalytics: Equatable, Sendable {
    let currentStreak: Int
    let longestStreak: Int
    let totalTonnage: Double
    let averageTonnagePerSession: Double
    let bestDayTonnage: Double
    let totalSets: Int
    let weeklyActivity: [DayActivity]
    let topExercises: [ExerciseVolume]
    let milestones: [Milestone]
    let insight: String

    static let empty = DashboardAnalytics(
        currentStreak: 0,
        longestStreak: 0,
        totalTonnage: 0,
        averageTonnagePerSession: 0,
        bestDayTonnage: 0,
        totalSets: 0,
        weeklyActivity: [],
        topExercises: [],
        milestones: [],
        insight: "Log your first set to start building the tower."
    )
}

struct DayActivity: Identifiable, Equatable, Sendable {
    var id: Date { day }
    let day: Date
    let tonnage: Double
    let label: String

    var intensity: Double {
        guard tonnage > 0 else { return 0 }
        return min(1, tonnage / 5_000)
    }
}

struct ExerciseVolume: Identifiable, Equatable, Sendable {
    var id: String { name }
    let name: String
    let tonnage: Double
}

enum Milestone: String, CaseIterable, Identifiable, Sendable {
    case firstFloor
    case tenFloors
    case fiftyFloors
    case firstPR
    case weekStreak
    case tonnage1k
    case tonnage10k
    case hundredSets

    var id: String { rawValue }

    var title: String {
        switch self {
        case .firstFloor: return "Ground Floor"
        case .tenFloors: return "Skyline"
        case .fiftyFloors: return "Cloud Nine"
        case .firstPR: return "Record Breaker"
        case .weekStreak: return "Week Warrior"
        case .tonnage1k: return "1K Club"
        case .tonnage10k: return "10K Titan"
        case .hundredSets: return "Century"
        }
    }

    var subtitle: String {
        switch self {
        case .firstFloor: return "Complete your first floor"
        case .tenFloors: return "Reach 10 floors"
        case .fiftyFloors: return "Reach 50 floors"
        case .firstPR: return "Set your first PR"
        case .weekStreak: return "7-day training streak"
        case .tonnage1k: return "1,000 kg total volume"
        case .tonnage10k: return "10,000 kg total volume"
        case .hundredSets: return "Log 100 sets"
        }
    }

    var symbolName: String {
        switch self {
        case .firstFloor: return "building.fill"
        case .tenFloors: return "building.2.fill"
        case .fiftyFloors: return "cloud.fill"
        case .firstPR: return "trophy.fill"
        case .weekStreak: return "flame.fill"
        case .tonnage1k: return "scalemass.fill"
        case .tonnage10k: return "bolt.circle.fill"
        case .hundredSets: return "100.circle.fill"
        }
    }

    func isUnlocked(floors: Int, prCount: Int, streak: Int, tonnage: Double, sets: Int) -> Bool {
        switch self {
        case .firstFloor: return floors >= 1
        case .tenFloors: return floors >= 10
        case .fiftyFloors: return floors >= 50
        case .firstPR: return prCount >= 1
        case .weekStreak: return streak >= 7
        case .tonnage1k: return tonnage >= 1_000
        case .tonnage10k: return tonnage >= 10_000
        case .hundredSets: return sets >= 100
        }
    }
}

enum DashboardAnalyticsBuilder {
    static func build(
        workouts: [Workout],
        personalRecords: [PersonalRecord],
        towerHeight: TowerHeight,
        calendar: Calendar = .current
    ) -> DashboardAnalytics {
        let grouped = Dictionary(grouping: workouts) { calendar.startOfDay(for: $0.date) }
        let sortedDays = grouped.keys.sorted()
        let streaks = calculateStreaks(days: sortedDays, calendar: calendar)

        let totalTonnage = workouts.reduce(0) { $0 + $1.totalTonnage }
        let totalSets = workouts.reduce(0) { $0 + $1.sets.count }
        let sessionCount = sortedDays.count
        let bestDay = grouped.values.map { $0.reduce(0) { $0 + $1.totalTonnage } }.max() ?? 0

        let weekly = (0..<7).reversed().map { offset -> DayActivity in
            let day = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -offset, to: .now) ?? .now)
            let tonnage = grouped[day]?.reduce(0) { $0 + $1.totalTonnage } ?? 0
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return DayActivity(day: day, tonnage: tonnage, label: formatter.string(from: day))
        }

        var exerciseMap: [String: Double] = [:]
        for workout in workouts {
            for set in workout.sets {
                exerciseMap[set.exerciseName, default: 0] += set.tonnage
            }
        }
        let topExercises = exerciseMap
            .map { ExerciseVolume(name: $0.key, tonnage: $0.value) }
            .sorted { $0.tonnage > $1.tonnage }
            .prefix(5)
            .map { $0 }

        let milestones = Milestone.allCases.compactMap { milestone in
            milestone.isUnlocked(
                floors: towerHeight.floors,
                prCount: personalRecords.count,
                streak: streaks.current,
                tonnage: totalTonnage,
                sets: totalSets
            ) ? milestone : nil
        }

        let insight = makeInsight(
            streak: streaks.current,
            floors: towerHeight.floors,
            prCount: personalRecords.count,
            weekly: weekly
        )

        return DashboardAnalytics(
            currentStreak: streaks.current,
            longestStreak: streaks.longest,
            totalTonnage: totalTonnage,
            averageTonnagePerSession: sessionCount > 0 ? totalTonnage / Double(sessionCount) : 0,
            bestDayTonnage: bestDay,
            totalSets: totalSets,
            weeklyActivity: weekly,
            topExercises: topExercises,
            milestones: milestones,
            insight: insight
        )
    }

    private static func calculateStreaks(days: [Date], calendar: Calendar) -> (current: Int, longest: Int) {
        guard !days.isEmpty else { return (0, 0) }

        let daySet = Set(days)
        var longest = 0
        var run = 0
        var previous: Date?

        for day in days {
            if let previous, calendar.dateComponents([.day], from: previous, to: day).day == 1 {
                run += 1
            } else {
                run = 1
            }
            longest = max(longest, run)
            previous = day
        }

        var current = 0
        var cursor = calendar.startOfDay(for: .now)
        if !daySet.contains(cursor),
           let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) {
            cursor = calendar.startOfDay(for: yesterday)
        }

        while daySet.contains(cursor) {
            current += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = calendar.startOfDay(for: previous)
        }

        return (current, longest)
    }

    private static func makeInsight(
        streak: Int,
        floors: Int,
        prCount: Int,
        weekly: [DayActivity]
    ) -> String {
        if streak >= 7 {
            return "You're on fire — \(streak) days in a row. Keep stacking floors."
        }
        if prCount > 0 {
            return "\(prCount) personal record\(prCount == 1 ? "" : "s") crushed. The tower is rising."
        }
        if floors >= 10 {
            return "\(floors) floors high and climbing. Consistency builds skyscrapers."
        }
        let activeDays = weekly.filter { $0.tonnage > 0 }.count
        if activeDays >= 4 {
            return "Solid week — \(activeDays) training days logged. Momentum is yours."
        }
        return "Every set is a floor. Show up today and add one more."
    }
}
