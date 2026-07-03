import Foundation
import SwiftData

/// Concrete `TrainingPreferencesRepository` backed by a SwiftData `ModelContext`.
/// Stores preferences as a single row, acting as a lightweight singleton.
@MainActor
final class SwiftDataTrainingPreferencesRepository: TrainingPreferencesRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetch() async throws -> TrainingPreferences? {
        try modelContext.fetch(FetchDescriptor<TrainingPreferencesModel>()).first?.toDomain()
    }

    func save(_ preferences: TrainingPreferences) async throws {
        let existing = try modelContext.fetch(FetchDescriptor<TrainingPreferencesModel>())
        existing.forEach { modelContext.delete($0) }
        modelContext.insert(TrainingPreferencesModel(preferences: preferences))
        try modelContext.save()
    }

    func deleteAll() async throws {
        try modelContext.delete(model: TrainingPreferencesModel.self)
        try modelContext.save()
    }
}
