import UIKit

/// Stateless wrapper around `UIFeedbackGenerator`. Injected via `AppDependencies` rather than
/// accessed as a global singleton, so views and view models stay testable.
struct HapticsService: Sendable {
    func lightTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    /// A new floor rising into place.
    func newFloor() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    /// The "moment of outcome" — a strong hit for a brand-new personal record.
    func personalRecord() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred(intensity: 1.0)
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }

    func restTimerComplete() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
