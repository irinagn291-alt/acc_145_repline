import SwiftUI

/// Brief "moment of outcome" fanfare overlay shown when a set sets a new personal record.
struct PersonalRecordFanfareView: View {
    let workoutSet: WorkoutSet
    @State private var hasAppeared = false

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "crown.fill")
                .font(.system(size: 42))
                .foregroundStyle(AppColor.accent)
            Text("New Record!")
                .font(.system(.title2, design: .rounded, weight: .black))
                .foregroundStyle(AppColor.text)
            Text("\(workoutSet.exerciseName) · \(Int(workoutSet.weight)) kg × \(workoutSet.reps)")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(AppColor.text.opacity(0.75))
        }
        .padding(28)
        .claySurface(fill: AppColor.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .strokeBorder(AppColor.accent, lineWidth: 2)
        )
        .scaleEffect(hasAppeared ? 1 : 0.6)
        .opacity(hasAppeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                hasAppeared = true
            }
        }
    }
}

#Preview {
    PersonalRecordFanfareView(workoutSet: WorkoutSet(workoutID: UUID(), exerciseName: "Bench Press", weight: 90, reps: 3, isPersonalRecord: true))
        .background(AppColor.background)
}
