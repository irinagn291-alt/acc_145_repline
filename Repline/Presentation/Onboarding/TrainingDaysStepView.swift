import SwiftUI

/// Onboarding screen 3: "Training Days" — weekday selection for reminders.
struct TrainingDaysStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingScaffold(
            title: "Training Days",
            subtitle: "Pick your days — we'll remind you when the tower needs a floor",
            ctaTitle: "Next",
            isCTAEnabled: viewModel.canProceed,
            onCTA: viewModel.advance
        ) {
            HStack(spacing: 8) {
                ForEach(Weekday.allCases) { day in
                    let isSelected = viewModel.selectedDays.contains(day)
                    Button {
                        if isSelected {
                            viewModel.selectedDays.remove(day)
                        } else {
                            viewModel.selectedDays.insert(day)
                        }
                    } label: {
                        Text(day.shortTitle)
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(isSelected ? .white : AppColor.text)
                            .frame(width: 42, height: 42)
                            .background(
                                Circle().fill(isSelected ? AppColor.primary : AppColor.surface)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    TrainingDaysStepView(viewModel: OnboardingViewModel(dependencies: PreviewSupport.dependencies))
}
