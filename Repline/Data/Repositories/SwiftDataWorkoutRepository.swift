import Foundation
import SwiftData

/// Concrete `WorkoutRepository` backed by a SwiftData `ModelContext`.
/// Pinned to the main actor because `ModelContext` is not safe to share across threads.
@MainActor
final class SwiftDataWorkoutRepository: WorkoutRepository {
    private let modelContext: ModelContext
    private let calendar: Calendar

    init(modelContext: ModelContext, calendar: Calendar = .current) {
        self.modelContext = modelContext
        self.calendar = calendar
    }

    func fetchAll() async throws -> [Workout] {
        let descriptor = FetchDescriptor<WorkoutModel>(sortBy: [SortDescriptor(\.date)])
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func fetchWorkout(id: UUID) async throws -> Workout? {
        let descriptor = FetchDescriptor<WorkoutModel>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first?.toDomain()
    }

    func fetchWorkout(on day: Date) async throws -> Workout? {
        try fetchModel(on: day)?.toDomain()
    }

    func appendSet(_ set: WorkoutSet, programType: ProgramType?, to day: Date) async throws -> Workout {
        let workoutModel: WorkoutModel
        if let existing = try fetchModel(on: day) {
            workoutModel = existing
            if let programType, workoutModel.programTypeRawValue == nil {
                workoutModel.programTypeRawValue = programType.rawValue
            }
        } else {
            workoutModel = WorkoutModel(id: set.workoutID, date: calendar.startOfDay(for: day), programTypeRawValue: programType?.rawValue)
            modelContext.insert(workoutModel)
        }

        let setModel = WorkoutSetModel(set: set)
        setModel.workout = workoutModel
        modelContext.insert(setModel)
        workoutModel.sets?.append(setModel)

        try modelContext.save()
        return workoutModel.toDomain()
    }

    func deleteWorkout(id: UUID) async throws {
        let descriptor = FetchDescriptor<WorkoutModel>(predicate: #Predicate { $0.id == id })
        if let model = try modelContext.fetch(descriptor).first {
            modelContext.delete(model)
            try modelContext.save()
        }
    }

    func deleteAll() async throws {
        try modelContext.delete(model: WorkoutModel.self)
        try modelContext.delete(model: WorkoutSetModel.self)
        try modelContext.save()
    }

    private func fetchModel(on day: Date) throws -> WorkoutModel? {
        let start = calendar.startOfDay(for: day)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return nil }
        let descriptor = FetchDescriptor<WorkoutModel>(
            predicate: #Predicate { $0.date >= start && $0.date < end }
        )
        return try modelContext.fetch(descriptor).first
    }
}
