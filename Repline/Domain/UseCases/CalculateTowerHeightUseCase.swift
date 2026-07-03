import Foundation

/// Computes cumulative tonnage across all logged sets and maps it to the tower's height —
/// the app's core "Naming": tonnage/volume in, tower height out.
protocol CalculateTowerHeightUseCase {
    func execute(workouts: [Workout]) -> TowerHeight
}

final class DefaultCalculateTowerHeightUseCase: CalculateTowerHeightUseCase {
    func execute(workouts: [Workout]) -> TowerHeight {
        let totalTonnage = workouts.reduce(0) { $0 + $1.totalTonnage }
        return TowerHeight(totalTonnage: totalTonnage)
    }
}
