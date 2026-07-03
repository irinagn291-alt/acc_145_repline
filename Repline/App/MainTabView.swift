import SwiftUI

/// Root tab bar once onboarding is complete: Tower, Dashboard, Settings.
struct MainTabView: View {
    let dependencies: AppDependencies

    var body: some View {
        TabView {
            TowerView(dependencies: dependencies)
                .tabItem { Label("Tower", systemImage: "building.2.fill") }

            DashboardView(dependencies: dependencies)
                .tabItem { Label("Analytics", systemImage: "chart.bar.fill") }

            SettingsView(dependencies: dependencies)
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(AppColor.primary)
    }
}

#Preview {
    MainTabView(dependencies: PreviewSupport.dependencies)
}
