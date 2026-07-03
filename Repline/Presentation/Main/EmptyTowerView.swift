import SwiftUI

/// Empty state for the tower screen — exact spec copy.
struct EmptyTowerView: View {
    let onAddSet: () -> Void
    let onBrowseTemplates: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "building.2.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppColor.primary)

            Text("The foundation is empty. Your first set lays the first floor.")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button("Add Set", action: onAddSet)
                .buttonStyle(ClayButtonStyle())
                .padding(.horizontal, 60)

            Button("Browse Workouts", action: onBrowseTemplates)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }
}

#Preview {
    EmptyTowerView(onAddSet: {}, onBrowseTemplates: {})
}
