import Foundation

/// Shared `@AppStorage` keys for simple, non-domain settings flags.
enum SettingsStorageKey {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let healthSyncEnabled = "healthSyncEnabled"
    static let notificationsEnabled = "notificationsEnabled"
    static let appearanceRawValue = "appearanceRawValue"
}
