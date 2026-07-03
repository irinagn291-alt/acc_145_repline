import SwiftUI

/// Settings screen: appearance, notifications, export, about/reset.
struct SettingsView: View {
    @State private var viewModel: SettingsViewModel
    private let dependencies: AppDependencies

    @AppStorage(SettingsStorageKey.appearanceRawValue) private var appearanceRawValue = AppAppearance.system.rawValue
    @AppStorage(SettingsStorageKey.notificationsEnabled) private var notificationsEnabled = false
    @AppStorage(SettingsStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    @State private var trainingDays: Set<Weekday> = []
    @State private var showResetConfirmation = false

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = State(initialValue: SettingsViewModel(dependencies: dependencies))
    }

    var body: some View {
        NavigationStack {
            Form {
                appearanceSection
                notificationsSection
                exportSection
                aboutSection
            }
            .navigationTitle("Settings")
            .task {
                let preferences = try? await dependencies.fetchTrainingPreferences.execute()
                trainingDays = preferences?.trainingDays ?? []
            }
            .confirmationDialog(
                "Delete all data?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Everything", role: .destructive) {
                    Task {
                        await viewModel.resetAllData()
                        hasCompletedOnboarding = false
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $appearanceRawValue) {
                ForEach(AppAppearance.allCases) { appearance in
                    Text(appearance.title).tag(appearance.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var notificationsSection: some View {
        Section("Reminders") {
            Toggle("Workout reminders", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { _, newValue in
                    Task { await viewModel.handleNotificationsToggle(isEnabled: newValue, trainingDays: trainingDays) }
                }
        }
    }

    private var exportSection: some View {
        Section("Export") {
            if let csv = viewModel.exportedCSV {
                ShareLink(item: csv, preview: SharePreview("Repline Workout History")) {
                    Label("Share File", systemImage: "square.and.arrow.up")
                }
            }
            Button {
                Task { await viewModel.exportHistory() }
            } label: {
                if viewModel.isExporting {
                    Text("Preparing...")
                } else {
                    Label("Export Full History", systemImage: "tray.and.arrow.down")
                }
            }
            .disabled(viewModel.isExporting)
            Text("Your full workout history is free to export anytime.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Repline")
                Spacer()
                Text("Every set, one floor higher.")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            Text("Repline does not provide medical advice. Consult a physician before starting any exercise program.")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button("Reset All Data", role: .destructive) {
                showResetConfirmation = true
            }
        }
    }
}

#Preview {
    SettingsView(dependencies: PreviewSupport.dependencies)
}
