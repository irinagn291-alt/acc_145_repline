import SwiftUI

/// A single personal-record list row on the dashboard.
struct PersonalRecordRow: View {
    let record: PersonalRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .foregroundStyle(AppColor.accent)
                .frame(width: 32, height: 32)
                .background(Circle().fill(AppColor.background))

            VStack(alignment: .leading, spacing: 2) {
                Text(record.exerciseName)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(AppColor.text)
                Text(record.achievedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(AppColor.text.opacity(0.5))
            }

            Spacer()

            Text("\(Int(record.bestWeight)) kg × \(record.bestReps)")
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.accent)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    PersonalRecordRow(record: PersonalRecord(exerciseName: "Bench Press", bestWeight: 100, bestReps: 3, estimatedOneRepMax: 110, achievedDate: .now, achievedSetID: UUID()))
        .padding()
        .background(AppColor.background)
}
