import SwiftUI

extension Color {
    // Backgrounds
    public static let appBackground = Color(hex: "0D182A")
    public static let appSurface = Color(hex: "152535")
    public static let appSurfaceElevated = Color(hex: "1E3347")
    
    // Brand
    public static let primaryGold = Color(hex: "FFCB3E")
    public static let primaryBlue = Color(hex: "2D98E8")
    
    // Feedback
    public static let appSuccess = Color(hex: "4FD97D")
    public static let appError = Color(hex: "FF5D5D")
    public static let appWarning = Color(hex: "FF8C42")
    public static let streakFlame = Color(hex: "FF6B35")
    
    // Text
    public static let textPrimary = Color(hex: "FFFFFF")
    public static let textSecondary = Color(hex: "7A9A88")
    public static let textMuted = Color(hex: "4A6880")
    
    // Category Accents
    public static let accentWork = Color(hex: "4FC3F7")
    public static let accentStreet = Color(hex: "FFB465")
    public static let accentSMS = Color(hex: "CE93D8")
    public static let accentSocial = Color(hex: "81C784")
    public static let accentDating = Color(hex: "F48FB1")
    public static let accentSwearing = Color(hex: "EF9A9A")
    public static let accentFiller = Color(hex: "FFD54F")
    
    // Helper Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Font {
    // SF Pro Rounded font helper
    public static func sfRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .rounded)
    }
    
    // SF Pro Standard text font helper
    public static func sfStandard(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .default)
    }
}
