import SwiftUI

/// Sheet form for logging a single set — the "+ Set" action that raises a new floor.
struct AddSetSheet: View {
    let readySets: [TemplateSet]
    let onSave: (String, Double, Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var exerciseName = ""
    @State private var weightText = ""
    @State private var repsText = ""

    var body: some View {
        NavigationStack {
            Form {
                if !readySets.isEmpty {
                    Section("Ready Sets") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(readySets) { set in
                                    Button {
                                        apply(set)
                                    } label: {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(set.exerciseName)
                                                .font(.caption.weight(.bold))
                                                .lineLimit(1)
                                            Text(prefillLabel(set))
                                                .font(.caption2)
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }

                Section("Exercise") {
                    TextField("e.g. Bench Press", text: $exerciseName)
                }

                Section("Weight & Reps") {
                    HStack {
                        TextField("Weight, kg", text: $weightText)
                            .keyboardType(.decimalPad)
                        Text("kg").foregroundStyle(.secondary)
                    }
                    HStack {
                        TextField("Reps", text: $repsText)
                            .keyboardType(.numberPad)
                        Text("reps").foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Add Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let weight = Double(weightText.replacingOccurrences(of: ",", with: ".")), let reps = Int(repsText) else { return }
                        onSave(exerciseName, weight, reps)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        !exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && Double(weightText.replacingOccurrences(of: ",", with: ".")) != nil
            && Int(repsText) != nil
    }

    private func apply(_ set: TemplateSet) {
        exerciseName = set.exerciseName
        weightText = set.weight.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(set.weight))
            : String(format: "%.1f", set.weight)
        repsText = String(set.reps)
    }

    private func prefillLabel(_ set: TemplateSet) -> String {
        let w = set.weight.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(set.weight)) : String(format: "%.1f", set.weight)
        return "\(w) kg × \(set.reps)"
    }
}

#Preview {
    AddSetSheet(
        readySets: WorkoutTemplateCatalog.quickSets(for: .push, experience: .intermediate),
        onSave: { _, _, _ in }
    )
}
