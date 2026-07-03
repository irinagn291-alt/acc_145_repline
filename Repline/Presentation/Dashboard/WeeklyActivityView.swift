import SwiftUI

/// 7-day activity heatmap showing training intensity.
struct WeeklyActivityView: View {
    let activity: [DayActivity]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)

            HStack(spacing: 8) {
                ForEach(activity) { day in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(barColor(for: day.intensity))
                            .frame(height: max(12, 80 * day.intensity))
                            .frame(maxHeight: 80, alignment: .bottom)
                            .animation(.spring(response: 0.4), value: day.intensity)

                        Text(day.label)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(AppColor.text.opacity(0.55))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 100, alignment: .bottom)
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }

    private func barColor(for intensity: Double) -> Color {
        if intensity == 0 { return AppColor.text.opacity(0.08) }
        return AppColor.primary.opacity(0.3 + intensity * 0.7)
    }
}

#Preview {
    WeeklyActivityView(activity: [
        DayActivity(day: .now, tonnage: 3200, label: "Fri"),
        DayActivity(day: .now, tonnage: 0, label: "Thu"),
        DayActivity(day: .now, tonnage: 1800, label: "Wed"),
    ])
    .background(AppColor.background)
}
