import Foundation

/// A single point in the volume-over-time series shown on the dashboard.
struct VolumeDataPoint: Identifiable, Equatable, Sendable {
    var id: Date { day }
    let day: Date
    let tonnage: Double
    let cumulativeTonnage: Double
}

/// Builds the day-by-day and cumulative tonnage series used to chart volume and tower growth.
protocol FetchVolumeAnalyticsUseCase {
    func execute(workouts: [Workout]) -> [VolumeDataPoint]
}

final class DefaultFetchVolumeAnalyticsUseCase: FetchVolumeAnalyticsUseCase {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func execute(workouts: [Workout]) -> [VolumeDataPoint] {
        let grouped = Dictionary(grouping: workouts) { calendar.startOfDay(for: $0.date) }
        let sortedDays = grouped.keys.sorted()

        var cumulative: Double = 0
        return sortedDays.map { day in
            let tonnage = grouped[day]?.reduce(0) { $0 + $1.totalTonnage } ?? 0
            cumulative += tonnage
            return VolumeDataPoint(day: day, tonnage: tonnage, cumulativeTonnage: cumulative)
        }
    }
}
