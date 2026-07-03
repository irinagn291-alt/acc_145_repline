import Foundation

/// The gamified mapping of cumulative tonnage to a climbable tower: tonnage = height.
struct TowerHeight: Equatable, Sendable {
    /// Cumulative tonnage (kg) the height is derived from.
    let totalTonnage: Double
    /// Whole floors completed.
    let floors: Int
    /// Visual height in meters (one floor = `Self.tonnagePerFloor` kg, `Self.metersPerFloor` m tall).
    let meters: Double
    /// Progress (0...1) towards the next floor.
    let progressToNextFloor: Double

    static let tonnagePerFloor: Double = 500
    static let metersPerFloor: Double = 3

    static let zero = TowerHeight(totalTonnage: 0, floors: 0, meters: 0, progressToNextFloor: 0)

    init(totalTonnage: Double) {
        self.totalTonnage = max(0, totalTonnage)
        let exactFloors = self.totalTonnage / Self.tonnagePerFloor
        self.floors = Int(exactFloors)
        self.meters = exactFloors * Self.metersPerFloor
        self.progressToNextFloor = exactFloors - Double(floors)
    }

    private init(totalTonnage: Double, floors: Int, meters: Double, progressToNextFloor: Double) {
        self.totalTonnage = totalTonnage
        self.floors = floors
        self.meters = meters
        self.progressToNextFloor = progressToNextFloor
    }
}
