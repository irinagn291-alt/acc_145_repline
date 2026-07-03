import SwiftUI

/// Sheet to browse ready-made workouts and log full templates or individual sets.
struct WorkoutTemplatesSheet: View {
    let templates: [WorkoutTemplate]
    let programType: ProgramType?
    let onLogSet: (TemplateSet) -> Void
    let onLogTemplate: (WorkoutTemplate) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var expandedID: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(templates) { template in
                        templateCard(template)
                    }
                }
                .padding(16)
            }
            .background(AppColor.background.ignoresSafeArea())
            .navigationTitle(programType?.title ?? "Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func templateCard(_ template: WorkoutTemplate) -> some View {
        let isExpanded = expandedID == template.id

        return VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    expandedID = isExpanded ? nil : template.id
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: template.programType.symbolName)
                        .font(.title2)
                        .foregroundStyle(AppColor.primary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(AppColor.primary.opacity(0.15)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.name)
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(AppColor.text)
                        Text(template.subtitle)
                            .font(.caption)
                            .foregroundStyle(AppColor.text.opacity(0.55))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(template.setCount) sets")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppColor.secondary)
                        Text("\(Int(template.totalTonnage)) kg")
                            .font(.caption2)
                            .foregroundStyle(AppColor.text.opacity(0.45))
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppColor.text.opacity(0.4))
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(template.sets) { set in
                        HStack {
                            Text(set.label)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(AppColor.text.opacity(0.8))
                                .lineLimit(1)
                            Spacer()
                            Button {
                                onLogSet(set)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(AppColor.accent)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 4)
                    }

                    Button {
                        onLogTemplate(template)
                        dismiss()
                    } label: {
                        Label("Log All \(template.setCount) Sets", systemImage: "bolt.fill")
                    }
                    .buttonStyle(ClayButtonStyle(tint: AppColor.secondary))
                    .padding(.top, 4)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .claySurface(fill: AppColor.surface)
    }
}

#Preview {
    WorkoutTemplatesSheet(
        templates: WorkoutTemplateCatalog.templates(for: .push, experience: .intermediate),
        programType: .push,
        onLogSet: { _ in },
        onLogTemplate: { _ in }
    )
}
