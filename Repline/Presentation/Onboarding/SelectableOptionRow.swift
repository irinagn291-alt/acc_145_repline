import SwiftUI

/// A clay-style selectable row used for single-choice onboarding questions.
struct SelectableOptionRow: View {
    let title: String
    let subtitle: String
    let symbolName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: symbolName)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : AppColor.primary)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle().fill(isSelected ? AppColor.primary : AppColor.background)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(AppColor.text)
                    Text(subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(AppColor.text.opacity(0.6))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppColor.accent)
                }
            }
            .padding(16)
            .claySurface(fill: isSelected ? AppColor.surface.opacity(0.9) : AppColor.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(isSelected ? AppColor.primary : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
