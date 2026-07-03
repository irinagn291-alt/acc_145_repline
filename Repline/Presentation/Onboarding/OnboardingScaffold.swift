import SwiftUI

/// Shared layout for every onboarding step: heading, scrollable content, and a bottom CTA.
struct OnboardingScaffold<Content: View>: View {
    let title: String
    let subtitle: String
    let ctaTitle: String
    let isCTAEnabled: Bool
    let onCTA: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(.largeTitle, design: .rounded, weight: .black))
                            .foregroundStyle(AppColor.text)
                        Text(subtitle)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(AppColor.text.opacity(0.65))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    content
                }
                .padding(24)
            }

            Button(ctaTitle, action: onCTA)
                .buttonStyle(ClayButtonStyle())
                .disabled(!isCTAEnabled)
                .opacity(isCTAEnabled ? 1 : 0.5)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .padding(.top, 8)
        }
    }
}
