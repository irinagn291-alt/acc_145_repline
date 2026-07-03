import SwiftUI
import Charts

/// Horizontal bar chart of top exercises by volume.
struct ExerciseBreakdownView: View {
    let exercises: [ExerciseVolume]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Exercises")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)

            if exercises.isEmpty {
                Text("Log sets to see your exercise breakdown.")
                    .font(.subheadline)
                    .foregroundStyle(AppColor.text.opacity(0.55))
            } else {
                Chart(exercises) { item in
                    BarMark(
                        x: .value("Volume", item.tonnage),
                        y: .value("Exercise", item.name)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColor.secondary, AppColor.primary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(6)
                }
                .frame(height: CGFloat(exercises.count) * 36 + 16)
                .chartXAxis { AxisMarks(position: .bottom) }
            }
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ExerciseBreakdownView(exercises: [
        ExerciseVolume(name: "Bench Press", tonnage: 4200),
        ExerciseVolume(name: "Squat", tonnage: 3800),
        ExerciseVolume(name: "Deadlift", tonnage: 2900),
    ])
    .background(AppColor.background)
}
