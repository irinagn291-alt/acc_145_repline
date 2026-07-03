import SwiftUI

/// "Floor of the day" volume-goal card (Unique Feature Hook).
struct DailyFloorGoalCard: View {
    let goal: DailyFloorGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Floor of the Day")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(AppColor.text.opacity(0.7))
                Spacer()
                if goal.isComplete {
                    Label("Done", systemImage: "checkmark.seal.fill")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(AppColor.accent)
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(AppColor.background)
                    Capsule()
                        .fill(goal.isComplete ? AppColor.accent : AppColor.primary)
                        .frame(width: proxy.size.width * goal.progress)
                }
            }
            .frame(height: 10)

            Text("\(Int(goal.loggedTonnage)) / \(Int(goal.targetTonnage)) kg volume today")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(AppColor.text.opacity(0.55))
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }
}

#Preview {
    DailyFloorGoalCard(goal: DailyFloorGoal(targetTonnage: 3000, loggedTonnage: 1200))
        .background(AppColor.background)
}
