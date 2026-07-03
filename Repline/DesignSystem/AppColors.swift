import SwiftUI

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

/// Design tokens for Repline, sourced from the concept's Visual Direction spec.
enum AppColor {
    static let primary = Color(hex: "#FF6A3D")
    static let secondary = Color(hex: "#3D5AFE")
    static let accent = Color(hex: "#00E676")
    static let background = Color(hex: "#101418")
    static let surface = Color(hex: "#1B2127")
    static let text = Color(hex: "#F2F5F7")
}
