import SwiftUI

/// Onboarding screen 1: "Your goal?" — strength / mass / tone.
struct GoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingScaffold(
            title: "Your Goal?",
            subtitle: "The tower is built around what matters to you",
            ctaTitle: "Continue",
            isCTAEnabled: viewModel.canProceed,
            onCTA: viewModel.advance
        ) {
            VStack(spacing: 14) {
                ForEach(TrainingGoal.allCases) { goal in
                    SelectableOptionRow(
                        title: goal.title,
                        subtitle: goal.subtitle,
                        symbolName: goal.symbolName,
                        isSelected: viewModel.selectedGoal == goal
                    ) {
                        viewModel.selectedGoal = goal
                    }
                }
            }
        }
    }
}

#Preview {
    GoalStepView(viewModel: OnboardingViewModel(dependencies: PreviewSupport.dependencies))
}
