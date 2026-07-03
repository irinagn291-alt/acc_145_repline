import SwiftUI

/// Motivational insight card based on current training data.
struct DashboardInsightsCard: View {
    let insight: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(AppColor.accent)
                .frame(width: 44, height: 44)
                .background(Circle().fill(AppColor.accent.opacity(0.15)))

            Text(insight)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(AppColor.text.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }
}

#Preview {
    DashboardInsightsCard(insight: "You're on fire — 7 days in a row. Keep stacking floors.")
        .background(AppColor.background)
}
