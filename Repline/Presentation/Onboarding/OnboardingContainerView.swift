import SwiftUI

/// Hosts the 5-screen goal-setting onboarding pattern and reports completion upward.
struct OnboardingContainerView: View {
    @State private var viewModel: OnboardingViewModel
    let onFinish: () -> Void

    init(dependencies: AppDependencies, onFinish: @escaping () -> Void) {
        _viewModel = State(initialValue: OnboardingViewModel(dependencies: dependencies))
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()

            VStack(spacing: 0) {
                progressDots
                    .padding(.top, 24)
                    .padding(.bottom, 8)

                Group {
                    switch viewModel.step {
                    case .goal:
                        GoalStepView(viewModel: viewModel)
                    case .experience:
                        ExperienceStepView(viewModel: viewModel)
                    case .trainingDays:
                        TrainingDaysStepView(viewModel: viewModel)
                    case .towerDemo:
                        TowerDemoStepView(viewModel: viewModel)
                    case .buildFoundation:
                        BuildFoundationStepView(viewModel: viewModel, onFinish: onFinish)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .id(viewModel.step)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.step)
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingViewModel.Step.allCases, id: \.rawValue) { step in
                Capsule()
                    .fill(step.rawValue <= viewModel.step.rawValue ? AppColor.primary : AppColor.surface)
                    .frame(width: step == viewModel.step ? 28 : 8, height: 8)
            }
        }
    }
}

#Preview {
    OnboardingContainerView(dependencies: PreviewSupport.dependencies, onFinish: {})
}
