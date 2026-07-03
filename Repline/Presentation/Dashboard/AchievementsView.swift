import SwiftUI

/// Full achievements gallery showing locked and unlocked milestones.
struct AchievementsView: View {
    let unlocked: [Milestone]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                progressHeader

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Milestone.allCases) { milestone in
                        MilestoneBadgeView(
                            milestone: milestone,
                            isUnlocked: unlocked.contains(milestone)
                        )
                    }
                }
            }
            .padding(20)
        }
        .background(AppColor.background.ignoresSafeArea())
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(unlocked.count) / \(Milestone.allCases.count)")
                .font(.system(.largeTitle, design: .rounded, weight: .black))
                .foregroundStyle(AppColor.primary)

            Text("badges unlocked")
                .font(.subheadline)
                .foregroundStyle(AppColor.text.opacity(0.6))

            ProgressView(value: Double(unlocked.count), total: Double(Milestone.allCases.count))
                .tint(AppColor.primary)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .claySurface(fill: AppColor.surface)
    }
}

#Preview {
    NavigationStack {
        AchievementsView(unlocked: [.firstFloor, .firstPR, .tenFloors])
    }
}
