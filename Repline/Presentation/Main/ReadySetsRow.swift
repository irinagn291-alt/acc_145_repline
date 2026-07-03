import SwiftUI

/// Horizontal row of tappable preset sets for one-tap logging.
struct ReadySetsRow: View {
    let sets: [TemplateSet]
    let onLog: (TemplateSet) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ready Sets")
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text.opacity(0.55))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(sets) { set in
                        Button {
                            onLog(set)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(set.exerciseName)
                                    .font(.caption.weight(.bold))
                                    .lineLimit(1)
                                Text(weightReps(set))
                                    .font(.caption2)
                                    .foregroundStyle(AppColor.text.opacity(0.6))
                            }
                            .foregroundStyle(AppColor.text)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(AppColor.secondary.opacity(0.2))
                            )
                            .overlay(
                                Capsule().strokeBorder(AppColor.secondary.opacity(0.35), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func weightReps(_ set: TemplateSet) -> String {
        let w = set.weight > 0 ? "\(Int(set.weight)) kg" : "BW"
        return "\(w) × \(set.reps)"
    }
}

#Preview {
    ReadySetsRow(
        sets: WorkoutTemplateCatalog.quickSets(for: .push, experience: .intermediate),
        onLog: { _ in }
    )
    .padding()
    .background(AppColor.background)
}
