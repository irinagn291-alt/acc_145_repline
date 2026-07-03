import SwiftUI

/// Onboarding screen 4: "How the Tower Grows" — a short demo of the tonnage-to-height mechanic.
struct TowerDemoStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var demoFloors = 1

    var body: some View {
        OnboardingScaffold(
            title: "How the Tower Grows",
            subtitle: "Every set is volume. Volume is height.",
            ctaTitle: "Got It",
            isCTAEnabled: viewModel.canProceed,
            onCTA: viewModel.advance
        ) {
            VStack(spacing: 16) {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 6) {
                        ForEach(0..<demoFloors, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(index == demoFloors - 1 ? AppColor.primary : AppColor.secondary)
                                .frame(height: 34)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .frame(height: 220, alignment: .bottom)
                .frame(maxWidth: .infinity)

                Text("Set = +1 floor")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(AppColor.text.opacity(0.7))

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        demoFloors = min(demoFloors + 1, 6)
                    }
                } label: {
                    Text("+ Set")
                }
                .buttonStyle(ClayButtonStyle(tint: AppColor.secondary))
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    TowerDemoStepView(viewModel: OnboardingViewModel(dependencies: PreviewSupport.dependencies))
}
