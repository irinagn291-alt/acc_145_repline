import SwiftUI
import SwiftData

/// Switches between the onboarding flow and the main tab experience, wiring `AppDependencies`
/// from the shared `ModelContext` exactly once per app launch.
struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(SettingsStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(SettingsStorageKey.appearanceRawValue) private var appearanceRawValue = AppAppearance.system.rawValue
    @State private var dependencies: AppDependencies?

    var body: some View {
        Group {
            if let dependencies {
                if hasCompletedOnboarding {
                    MainTabView(dependencies: dependencies)
                } else {
                    OnboardingContainerView(dependencies: dependencies, onFinish: { hasCompletedOnboarding = true })
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColor.background)
            }
        }
        .tint(AppColor.accent)
        .preferredColorScheme(AppAppearance(rawValue: appearanceRawValue)?.colorScheme)
        .onAppear {
            if dependencies == nil {
                dependencies = AppDependencies(modelContext: modelContext)
            }
        }
    }
}
