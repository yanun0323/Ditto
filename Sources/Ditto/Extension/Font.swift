import SwiftUI

public enum DittoFont: CaseIterable {
    case Cubic11R
    case Huninn
    case Iansui
    case NotoSansTCBlack
    case NotoSansTCBold
    case NotoSansTCExtraBold
    case NotoSansTCExtraLight
    case NotoSansTCLight
    case NotoSansTCMedium
    case NotoSansTC
    case NotoSansTCSemiBold
    case NotoSansTCThin
    case RobotoBlack
    case RobotoBlackItalic
    case RobotoBold
    case RobotoBoldItalic
    case RobotoItalic
    case RobotoLight
    case RobotoLightItalic
    case RobotoMedium
    case RobotoMediumItalic
    case Roboto
    case RobotoThin
    case RobotoThinItalic
    
    var filename: String {
        switch self {
        case .Cubic11R:
            return "Cubic_11_R"
        case .Huninn:
            return "Huninn"
        case .Iansui:
            return "Iansui-Regular"
        case .NotoSansTCBlack:
            return "NotoSansTC-Black"
        case .NotoSansTCBold:
            return "NotoSansTC-Bold"
        case .NotoSansTCExtraBold:
            return "NotoSansTC-ExtraBold"
        case .NotoSansTCExtraLight:
            return "NotoSansTC-ExtraLight"
        case .NotoSansTCLight:
            return "NotoSansTC-Light"
        case .NotoSansTCMedium:
            return "NotoSansTC-Medium"
        case .NotoSansTC:
            return "NotoSansTC-Regular"
        case .NotoSansTCSemiBold:
            return "NotoSansTC-SemiBold"
        case .NotoSansTCThin:
            return "NotoSansTC-Thin"
        case .RobotoBlack:
            return "Roboto-Black"
        case .RobotoBlackItalic:
            return "Roboto-BlackItalic"
        case .RobotoBold:
            return "Roboto-Bold"
        case .RobotoBoldItalic:
            return "Roboto-BoldItalic"
        case .RobotoItalic:
            return "Roboto-Italic"
        case .RobotoLight:
            return "Roboto-Light"
        case .RobotoLightItalic:
            return "Roboto-LightItalic"
        case .RobotoMedium:
            return "Roboto-Medium"
        case .RobotoMediumItalic:
            return "Roboto-MediumItalic"
        case .Roboto:
            return "Roboto-Regular"
        case .RobotoThin:
            return "Roboto-Thin"
        case .RobotoThinItalic:
            return "Roboto-ThinItalic"
        }
    }
    
    public var name: String {
        switch self {
        case .Cubic11R:
            return "Cubic 11"
        case .Huninn:
            return "jf-openhuninn-2.0"
        case .Iansui:
            return "Iansui Regular"
        case .NotoSansTCBlack:
            return "Noto Sans TC Black"
        case .NotoSansTCBold:
            return "Noto Sans TC Bold"
        case .NotoSansTCExtraBold:
            return "Noto Sans TC ExtraBold"
        case .NotoSansTCExtraLight:
            return "Noto Sans TC ExtraLight"
        case .NotoSansTCLight:
            return "Noto Sans TC Light"
        case .NotoSansTCMedium:
            return "Noto Sans TC Medium"
        case .NotoSansTC:
            return "Noto Sans TC Regular"
        case .NotoSansTCSemiBold:
            return "Noto Sans TC SemiBold"
        case .NotoSansTCThin:
            return "Noto Sans TC Thin"
        case .RobotoBlack:
            return "Roboto Black"
        case .RobotoBlackItalic:
            return "Roboto Black Italic"
        case .RobotoBold:
            return "Roboto Bold"
        case .RobotoBoldItalic:
            return "Roboto Bold Italic"
        case .RobotoItalic:
            return "Roboto Italic"
        case .RobotoLight:
            return "Roboto Light"
        case .RobotoLightItalic:
            return "Roboto Light Italic"
        case .RobotoMedium:
            return "Roboto Medium"
        case .RobotoMediumItalic:
            return "Roboto Medium Italic"
        case .Roboto:
            return "Roboto"
        case .RobotoThin:
            return "Roboto Thin"
        case .RobotoThinItalic:
            return "Roboto Thin Italic"
        }
    }
}

extension View {
    @ViewBuilder
    public func font(name font: DittoFont, size: CGFloat) -> some View {
        self.font(.custom(font.name, size: size))
    }
    
    @ViewBuilder
    public func font(name font: DittoFont, _ style: Font.TextStyle = .body) -> some View {
        self.font(.custom(font.name, size: style.size))
    }
}

fileprivate extension Font.TextStyle {
    #if os(macOS)
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 26
        case .title:
            return 22
        case .title2:
            return 18
        case .title3:
            return 16
        case .headline:
            return 14
        case .subheadline:
            return 12
        case .body:
            return 14
        case .callout:
            return 13
        case .footnote:
            return 11
        case .caption:
            return 11
        case .caption2:
            return 11
        @unknown default:
            return 17
        }
    }
    #else
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 32
        case .title:
            return 27
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 18
        case .subheadline:
            return 15
        case .body:
            return 17
        case .callout:
            return 16
        case .footnote:
            return 14
        case .caption:
            return 13
        case .caption2:
            return 12
        @unknown default:
            return 17
        }
    }
    #endif
}

#if DEBUG
#Preview {
    Ditto.registerFonts([.Roboto, .Cubic11R])
    return FontTestView(26, .largeTitle, font: .Cubic11R)
}

@ViewBuilder
func FontTestView(_ size: CGFloat, _ style: Font.TextStyle, font: DittoFont) -> some View {
    VStack {
        Text("Font Test 測試")
            .font(name: font, size: size)
        Text("Font Test 測試")
            .font(.system(style))
    }
    .paddings()
}
#endif
