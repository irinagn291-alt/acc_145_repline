import SwiftUI

/// Horizontal scroll of unlocked achievement badges with link to full list.
struct MilestonesSectionView: View {
    let unlocked: [Milestone]
    let onViewAll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Achievements")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(AppColor.text)
                Spacer()
                Button("View All", action: onViewAll)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(AppColor.secondary)
            }

            if unlocked.isEmpty {
                Text("Complete workouts to unlock badges.")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.text.opacity(0.55))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(unlocked) { milestone in
                            MilestoneBadgeView(milestone: milestone, isUnlocked: true)
                        }
                    }
                }
            }
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }
}

struct MilestoneBadgeView: View {
    let milestone: Milestone
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: milestone.symbolName)
                .font(.title2)
                .foregroundStyle(isUnlocked ? AppColor.primary : AppColor.text.opacity(0.25))
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(isUnlocked ? AppColor.primary.opacity(0.15) : AppColor.text.opacity(0.05))
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            isUnlocked ? AppColor.primary.opacity(0.4) : Color.clear,
                            lineWidth: 1.5
                        )
                )

            Text(milestone.title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(isUnlocked ? AppColor.text : AppColor.text.opacity(0.35))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 72)
        }
        .opacity(isUnlocked ? 1 : 0.5)
    }
}

#Preview {
    MilestonesSectionView(unlocked: [.firstFloor, .firstPR, .weekStreak], onViewAll: {})
        .background(AppColor.background)
}
