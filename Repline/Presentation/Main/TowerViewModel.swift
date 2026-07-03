import Foundation

/// Drives the vertical "climb" tower screen: loads workouts, logs new sets, auto-detects PRs,
/// tracks the rest timer, and surfaces the daily floor goal.
@MainActor
@Observable
final class TowerViewModel {
    private(set) var workouts: [Workout] = []
    private(set) var towerHeight: TowerHeight = .zero
    private(set) var dailyGoal: DailyFloorGoal?
    private(set) var preferences: TrainingPreferences = .default
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var selectedProgramType: ProgramType?
    var isShowingAddSet = false
    var isShowingTemplates = false
    var templateFilterProgramType: ProgramType?

    var availableTemplates: [WorkoutTemplate] {
        if let filter = templateFilterProgramType {
            return WorkoutTemplateCatalog.templates(for: filter, experience: preferences.experience)
        }
        return WorkoutTemplateCatalog.allTemplates(experience: preferences.experience)
    }

    var readySets: [TemplateSet] {
        guard let program = selectedProgramType else {
            return WorkoutTemplateCatalog.allTemplates(experience: preferences.experience)
                .flatMap(\.sets)
                .prefix(8)
                .map { $0 }
        }
        return Array(WorkoutTemplateCatalog.quickSets(for: program, experience: preferences.experience).prefix(8))
    }

    private(set) var restSecondsRemaining: Int?
    private var restTimerTask: Task<Void, Never>?

    /// The set that just triggered a PR fanfare, cleared automatically after a short delay.
    private(set) var personalRecordFanfare: WorkoutSet?

    private let dependencies: AppDependencies
    private let restDuration = 90

    /// Every logged set, most recent floor first — the literal tower, top floor on top.
    var floors: [WorkoutSet] {
        workouts.flatMap(\.sets).sorted { $0.date > $1.date }
    }

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            workouts = try await dependencies.fetchWorkoutHistory.execute()
            preferences = try await dependencies.fetchTrainingPreferences.execute()
            recomputeDerivedState()
        } catch {
            errorMessage = "Failed to load workouts."
        }
    }

    func logSet(exerciseName: String, weight: Double, reps: Int) async {
        await logSetInternal(exerciseName: exerciseName, weight: weight, reps: reps, startRestAfter: true)
    }

    func logReadySet(_ set: TemplateSet) async {
        await logSetInternal(exerciseName: set.exerciseName, weight: set.weight, reps: set.reps, startRestAfter: true)
    }

    func logTemplate(_ template: WorkoutTemplate) async {
        selectedProgramType = template.programType
        var lastPR: WorkoutSet?

        for (index, set) in template.sets.enumerated() {
            let isLast = index == template.sets.count - 1
            if let outcome = await logSetInternal(
                exerciseName: set.exerciseName,
                weight: set.weight,
                reps: set.reps,
                startRestAfter: isLast,
                silent: !isLast
            ), outcome.isNewPersonalRecord {
                lastPR = outcome.set
            }
        }

        if let lastPR {
            dependencies.haptics.personalRecord()
            personalRecordFanfare = lastPR
            scheduleFanfareDismissal()
        } else {
            dependencies.haptics.newFloor()
        }
    }

    func showTemplates(for programType: ProgramType? = nil) {
        templateFilterProgramType = programType
        isShowingTemplates = true
    }

    @discardableResult
    private func logSetInternal(
        exerciseName: String,
        weight: Double,
        reps: Int,
        startRestAfter: Bool,
        silent: Bool = false
    ) async -> LoggedSetOutcome? {
        guard !exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, weight > 0, reps > 0 else { return nil }

        do {
            let outcome = try await dependencies.logSet.execute(
                exerciseName: exerciseName,
                weight: weight,
                reps: reps,
                programType: selectedProgramType,
                day: .now
            )
            mergeOutcome(outcome)

            if !silent {
                if outcome.isNewPersonalRecord {
                    dependencies.haptics.personalRecord()
                    personalRecordFanfare = outcome.set
                    scheduleFanfareDismissal()
                } else {
                    dependencies.haptics.newFloor()
                }
            }

            if startRestAfter {
                startRestTimer()
            }
            return outcome
        } catch {
            errorMessage = "Failed to log set."
            return nil
        }
    }

    func startRestTimer() {
        restTimerTask?.cancel()
        restSecondsRemaining = restDuration

        restTimerTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                await self.tickRestTimer()
            }
        }
    }

    func cancelRestTimer() {
        restTimerTask?.cancel()
        restTimerTask = nil
        restSecondsRemaining = nil
    }

    private func tickRestTimer() {
        guard let remaining = restSecondsRemaining else { return }
        if remaining <= 1 {
            restSecondsRemaining = nil
            restTimerTask?.cancel()
            restTimerTask = nil
            dependencies.haptics.restTimerComplete()
        } else {
            restSecondsRemaining = remaining - 1
        }
    }

    private func scheduleFanfareDismissal() {
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(2.5))
            self?.personalRecordFanfare = nil
        }
    }

    private func mergeOutcome(_ outcome: LoggedSetOutcome) {
        if let index = workouts.firstIndex(where: { $0.id == outcome.workout.id }) {
            workouts[index] = outcome.workout
        } else {
            workouts.append(outcome.workout)
        }
        recomputeDerivedState()
    }

    private func recomputeDerivedState() {
        towerHeight = dependencies.calculateTowerHeight.execute(workouts: workouts)
        dailyGoal = dependencies.calculateDailyFloorGoal.execute(workouts: workouts, preferences: preferences, day: .now, calendar: .current)
    }
}
