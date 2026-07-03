import SwiftUI

/// A single clay-style "floor" of the tower — one logged set.
struct FloorBlockView: View {
    let workoutSet: WorkoutSet

    private var blockHeight: CGFloat {
        min(120, max(64, 56 + workoutSet.tonnage / 25))
    }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(workoutSet.exerciseName)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(AppColor.text)
                        .lineLimit(1)
                    if workoutSet.isPersonalRecord {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundStyle(AppColor.accent)
                    }
                }
                Text("\(formattedWeight) kg × \(workoutSet.reps)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(AppColor.text.opacity(0.65))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(workoutSet.tonnage))")
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .foregroundStyle(workoutSet.isPersonalRecord ? AppColor.accent : AppColor.primary)
                Text("kg volume")
                    .font(.caption2)
                    .foregroundStyle(AppColor.text.opacity(0.5))
            }
        }
        .padding(.horizontal, 18)
        .frame(height: blockHeight)
        .frame(maxWidth: .infinity)
        .claySurface(fill: workoutSet.isPersonalRecord ? AppColor.primary.opacity(0.18) : AppColor.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .strokeBorder(workoutSet.isPersonalRecord ? AppColor.accent : .clear, lineWidth: 2)
        )
    }

    private var formattedWeight: String {
        workoutSet.weight.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(workoutSet.weight)) : String(format: "%.1f", workoutSet.weight)
    }
}

#Preview {
    VStack(spacing: 10) {
        FloorBlockView(workoutSet: WorkoutSet(workoutID: UUID(), exerciseName: "Bench Press", weight: 80, reps: 5, isPersonalRecord: true))
        FloorBlockView(workoutSet: WorkoutSet(workoutID: UUID(), exerciseName: "Barbell Squat", weight: 100, reps: 8))
    }
    .padding()
    .background(AppColor.background)
}
