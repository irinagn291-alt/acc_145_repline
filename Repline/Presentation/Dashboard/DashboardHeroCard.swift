import SwiftUI

/// Hero card with tower progress ring, streak, and total volume.
struct DashboardHeroCard: View {
    let towerHeight: TowerHeight
    let analytics: DashboardAnalytics

    var body: some View {
        HStack(spacing: 20) {
            TowerProgressRingView(
                progress: towerHeight.progressToNextFloor,
                floors: towerHeight.floors,
                meters: towerHeight.meters
            )

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(AppColor.primary)
                    Text("\(analytics.currentStreak) day streak")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(AppColor.text)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedTonnage(analytics.totalTonnage))
                        .font(.system(.title, design: .rounded, weight: .heavy))
                        .foregroundStyle(AppColor.secondary)
                    Text("total volume lifted")
                        .font(.caption)
                        .foregroundStyle(AppColor.text.opacity(0.55))
                }

                HStack(spacing: 16) {
                    miniStat(value: "\(analytics.totalSets)", label: "sets")
                    miniStat(value: formattedTonnage(analytics.bestDayTonnage), label: "best day")
                    miniStat(value: "\(analytics.longestStreak)d", label: "best streak")
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppColor.surface, AppColor.surface.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [AppColor.primary.opacity(0.4), AppColor.secondary.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: AppColor.primary.opacity(0.15), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 16)
    }

    private func miniStat(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)
            Text(label)
                .font(.caption2)
                .foregroundStyle(AppColor.text.opacity(0.5))
        }
    }

    private func formattedTonnage(_ value: Double) -> String {
        if value >= 10_000 {
            return String(format: "%.1fk kg", value / 1_000)
        }
        return "\(Int(value)) kg"
    }
}

/// Circular progress ring showing progress to the next floor.
struct TowerProgressRingView: View {
    let progress: Double
    let floors: Int
    let meters: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColor.text.opacity(0.08), lineWidth: 10)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [AppColor.primary, AppColor.secondary, AppColor.accent],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6), value: progress)

            VStack(spacing: 2) {
                Text("\(floors)")
                    .font(.system(.title, design: .rounded, weight: .black))
                    .foregroundStyle(AppColor.text)
                Text("floors")
                    .font(.caption2)
                    .foregroundStyle(AppColor.text.opacity(0.55))
                Text("\(Int(meters))m")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(AppColor.primary)
            }
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    DashboardHeroCard(
        towerHeight: TowerHeight(totalTonnage: 2_750),
        analytics: DashboardAnalytics(
            currentStreak: 5,
            longestStreak: 12,
            totalTonnage: 12_400,
            averageTonnagePerSession: 2_480,
            bestDayTonnage: 4_200,
            totalSets: 64,
            weeklyActivity: [],
            topExercises: [],
            milestones: [.firstFloor, .firstPR],
            insight: "Keep going!"
        )
    )
    .background(AppColor.background)
}
