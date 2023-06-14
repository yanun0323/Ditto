import SwiftUI

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
extension Color {
    public static let primary100: Self = .primary
    public static let primary75: Self = .primary.opacity(0.75)
    public static let primary50: Self = .primary.opacity(0.5)
    public static let primary25: Self = .primary.opacity(0.25)
    public static let section: Self  = .primary.opacity(0.1)
    public static let transparent: Self = .white.opacity(0.1).opacity(0.0101)
}

// MARK: Color Component
@available(iOS 16, macOS 13, watchOS 9, *)
extension Color {
#if os(macOS)
    typealias SystemColor = NSColor
#else
    typealias SystemColor = UIColor
#endif
    
    public var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
#if os(macOS)
        SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
#else
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
#endif
        
        return (r, g, b, a)
    }
}

// MARK: Codable
@available(iOS 16, macOS 13, watchOS 9, *)
extension Color: Codable {
    public enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        let a = try container.decode(Double.self, forKey: .alpha)
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.components else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
        try container.encode(colorComponents.alpha, forKey: .alpha)
    }
}

// MARK: Hex
@available(iOS 16, macOS 13, watchOS 9, *)
extension Color {
    public init(hex: String?) {
        guard let str = hex else {
            self = .clear
            return
        }
        
        if str.isEmpty {
            self = .clear
            return
        }
        
        let hex = str.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: /* RGB (12-bit) */
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: /* RGB (24-bit) */
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: /* ARGB (32-bit) */
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    public var hex: String {
        guard let c = SystemColor(self).cgColor.components else { return "" }
#if os(macOS)
        let r = UInt8((c[0]*255+0.5))
        let g = UInt8((c[1]*255+0.5))
        let b = UInt8((c[2]*255+0.5))
        let a = UInt8((c[3]*255+0.5))
#else
        let g = UInt8((c[0]*255+0.5)) // 22
        let b = UInt8((c[1]*255+0.5)) // 33
        let a = UInt8((c[2]*255+0.5)) // FF
        let r = UInt8((c[3]*255+0.5)) // 11
#endif
        
        return String(format:"#%02X%02X%02X%02X", r, g, b, a)
    }
}


