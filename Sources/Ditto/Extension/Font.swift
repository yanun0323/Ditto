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
    public func font(name font: DittoFont, size: CGFloat? = nil) -> some View {
        if let size = size {
            self.font(.custom(font.name, size: size))
        } else {
            #if os(macOS)
            self.font(.custom(font.name, size: 13))
            #else
            self.font(.custom(font.name, size: 17))
            #endif
        }
        
    }
}

#if DEBUG
#Preview {
    Ditto.registerFonts()
    return VStack {
        Text("Font Test 測試")
            .font(name: .Roboto)
        Text("Font Test 測試")
            .font(.custom(DittoFont.Cubic11R.name, size: 17))
        Text("Font Test 測試")
            .font(.custom(DittoFont.Cubic11R.name, fixedSize: 17))
        Text("Font Test 測試")
            .font(.body)
        Text("Font Test 測試")
            .font(.system(size: 17))
    }
    .paddings(30)
//    .dynamicTypeSize(.xLarge)
}
#endif
