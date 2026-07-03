import Foundation

/// Drives the 5-screen goal-setting onboarding flow and persists the result on completion.
@MainActor
@Observable
final class OnboardingViewModel {
    enum Step: Int, CaseIterable {
        case goal, experience, trainingDays, towerDemo, buildFoundation
    }

    private(set) var step: Step = .goal
    var selectedGoal: TrainingGoal?
    var selectedExperience: ExperienceLevel?
    var selectedDays: Set<Weekday> = []
    private(set) var isSaving = false

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var canProceed: Bool {
        switch step {
        case .goal: return selectedGoal != nil
        case .experience: return selectedExperience != nil
        case .trainingDays: return !selectedDays.isEmpty
        case .towerDemo: return true
        case .buildFoundation: return true
        }
    }

    func advance() {
        guard canProceed, let nextStep = Step(rawValue: step.rawValue + 1) else { return }
        step = nextStep
    }

    func goBack() {
        guard let previousStep = Step(rawValue: step.rawValue - 1) else { return }
        step = previousStep
    }

    func finish() async {
        guard let goal = selectedGoal, let experience = selectedExperience, !isSaving else { return }
        isSaving = true
        defer { isSaving = false }

        let preferences = TrainingPreferences(goal: goal, experience: experience, trainingDays: selectedDays)
        try? await dependencies.saveTrainingPreferences.execute(preferences)
        await dependencies.scheduleWorkoutReminders.execute(for: selectedDays)
    }
}
