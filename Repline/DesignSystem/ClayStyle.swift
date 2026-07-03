import SwiftUI

/// Shared 3D-claymorphism surface treatment: radius 26, soft volumetric shadow plus an inner
/// highlight, matching the concept's Visual Direction.
struct ClaySurface: ViewModifier {
    var cornerRadius: CGFloat = 26
    var fill: Color = AppColor.surface

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.16), Color.white.opacity(0)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: .black.opacity(0.45), radius: 14, x: 0, y: 10)
                    .shadow(color: Color.white.opacity(0.04), radius: 1, x: 0, y: 1)
            )
    }
}

extension View {
    func claySurface(cornerRadius: CGFloat = 26, fill: Color = AppColor.surface) -> some View {
        modifier(ClaySurface(cornerRadius: cornerRadius, fill: fill))
    }
}

/// A chunky, pill-shaped clay button style used for primary CTAs across the app.
struct ClayButtonStyle: ButtonStyle {
    var tint: Color = AppColor.primary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded, weight: .heavy))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(tint)
                    .overlay(
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: tint.opacity(0.55), radius: configuration.isPressed ? 4 : 12, x: 0, y: configuration.isPressed ? 2 : 8)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
