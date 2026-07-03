import SwiftUI

/// Onboarding screen 5: "Lay the Foundation" — final CTA that persists preferences and starts the app.
struct BuildFoundationStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    let onFinish: () -> Void

    var body: some View {
        OnboardingScaffold(
            title: "Lay the Foundation",
            subtitle: "Your first set becomes the first floor of your tower",
            ctaTitle: viewModel.isSaving ? "Building..." : "Build",
            isCTAEnabled: !viewModel.isSaving,
            onCTA: {
                Task {
                    await viewModel.finish()
                    onFinish()
                }
            }
        ) {
            VStack(spacing: 12) {
                Image(systemName: "building.2.crop.circle.fill")
                    .font(.system(size: 84))
                    .foregroundStyle(AppColor.primary)
                Text("Not medical advice. Consult a physician before starting any exercise program.")
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(AppColor.text.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    BuildFoundationStepView(viewModel: OnboardingViewModel(dependencies: PreviewSupport.dependencies), onFinish: {})
}
