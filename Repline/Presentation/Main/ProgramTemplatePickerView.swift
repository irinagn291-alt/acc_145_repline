import SwiftUI

/// Push/pull/legs program-template quick-picker (Unique Feature Hook).
struct ProgramTemplatePickerView: View {
    @Binding var selectedProgramType: ProgramType?
    let onPick: (ProgramType) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ProgramType.allCases) { program in
                    let isSelected = selectedProgramType == program
                    Button {
                        selectedProgramType = program
                        onPick(program)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: program.symbolName)
                            Text(program.title)
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .foregroundStyle(isSelected ? .white : AppColor.text)
                        .background(
                            Capsule().fill(isSelected ? AppColor.secondary : AppColor.surface)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ProgramTemplatePickerView(selectedProgramType: .constant(.push), onPick: { _ in })
        .background(AppColor.background)
}
