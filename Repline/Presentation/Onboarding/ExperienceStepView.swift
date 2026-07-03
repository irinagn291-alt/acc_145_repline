import SwiftUI

/// Onboarding screen 2: "Experience?" — experience level.
struct ExperienceStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingScaffold(
            title: "Experience?",
            subtitle: "This sets your starting daily volume goal",
            ctaTitle: "Next",
            isCTAEnabled: viewModel.canProceed,
            onCTA: viewModel.advance
        ) {
            VStack(spacing: 14) {
                ForEach(ExperienceLevel.allCases) { level in
                    SelectableOptionRow(
                        title: level.title,
                        subtitle: level.subtitle,
                        symbolName: "chart.bar.fill",
                        isSelected: viewModel.selectedExperience == level
                    ) {
                        viewModel.selectedExperience = level
                    }
                }
            }
        }
    }
}

#Preview {
    ExperienceStepView(viewModel: OnboardingViewModel(dependencies: PreviewSupport.dependencies))
}
