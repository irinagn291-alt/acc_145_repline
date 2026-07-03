import SwiftUI

/// Analytics screen: Swift Charts for volume/PRs over time.
struct DashboardView: View {
    @State private var viewModel: DashboardViewModel
    @State private var showAchievements = false

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: DashboardViewModel(dependencies: dependencies))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background.ignoresSafeArea()

                if viewModel.volumeSeries.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            DashboardHeroCard(
                                towerHeight: viewModel.towerHeight,
                                analytics: viewModel.analytics
                            )
                            DashboardInsightsCard(insight: viewModel.analytics.insight)
                            summaryRow
                            WeeklyActivityView(activity: viewModel.analytics.weeklyActivity)
                            VolumeChartView(series: viewModel.volumeSeries)
                            ExerciseBreakdownView(exercises: viewModel.analytics.topExercises)
                            MilestonesSectionView(
                                unlocked: viewModel.unlockedMilestones,
                                onViewAll: { showAchievements = true }
                            )
                            personalRecordsCard
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Analytics")
            .navigationDestination(isPresented: $showAchievements) {
                AchievementsView(unlocked: viewModel.unlockedMilestones)
            }
            .task { await viewModel.load() }
        }
    }

    private var summaryRow: some View {
        HStack(spacing: 12) {
            statCard(title: "Training Days", value: "\(viewModel.totalWorkoutDays)")
            statCard(title: "Tower Height", value: "\(Int(viewModel.towerHeight.meters)) m")
            statCard(title: "Records", value: "\(viewModel.personalRecords.count)")
        }
        .padding(.horizontal, 16)
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .heavy))
                .foregroundStyle(AppColor.primary)
            Text(title)
                .font(.caption2)
                .foregroundStyle(AppColor.text.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .claySurface(fill: AppColor.surface)
    }

    private var personalRecordsCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Personal Records")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)
                .padding(.bottom, 6)

            if viewModel.personalRecords.isEmpty {
                Text("No records yet — plenty of PRs ahead.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(AppColor.text.opacity(0.55))
            } else {
                ForEach(viewModel.personalRecords) { record in
                    PersonalRecordRow(record: record)
                    if record.id != viewModel.personalRecords.last?.id {
                        Divider().background(AppColor.text.opacity(0.1))
                    }
                }
            }
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(AppColor.secondary)
            Text("No analytics yet. Lay the first floor on the Tower tab.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(AppColor.text.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    DashboardView(dependencies: PreviewSupport.dependencies)
}
