import SwiftUI

/// Rest-timer countdown banner shown after logging a set (Unique Feature Hook: rest timer + haptics).
struct RestTimerBannerView: View {
    let secondsRemaining: Int
    let onSkip: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "timer")
                .font(.title3)
                .foregroundStyle(AppColor.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Rest")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(AppColor.text.opacity(0.6))
                Text(timeString)
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .foregroundStyle(AppColor.text)
                    .monospacedDigit()
            }

            Spacer()

            Button("Skip", action: onSkip)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.secondary)
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }

    private var timeString: String {
        String(format: "%d:%02d", secondsRemaining / 60, secondsRemaining % 60)
    }
}

#Preview {
    RestTimerBannerView(secondsRemaining: 87, onSkip: {})
        .background(AppColor.background)
}
