import SwiftData

/// Central registry of SwiftData model types for Repline.
/// Add each new @Model type to `allModels` as it is implemented.
enum AppSchema {
    static let allModels: [any PersistentModel.Type] = [
        WorkoutModel.self,
        WorkoutSetModel.self,
        PersonalRecordModel.self,
        TrainingPreferencesModel.self,
    ]
}
