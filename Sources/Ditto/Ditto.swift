import Foundation
import SwiftUI

public struct Ditto {
    @MainActor
    public static func registerFonts() {
        FontName.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        
        var error: Unmanaged<CFError>?
        let succeed = CTFontManagerRegisterGraphicsFont(font, &error)
        if let err = error {
            fatalError("Register graphics font \(fontName), err: \(err)")
        }
        
        if succeed {
            print("font \(fontName) registered")
        } else {
            fatalError("font \(fontName) register failed")
        }
    }
}

public enum FontName: String, CaseIterable {
    case ChenYuluoyan_Thin_Monospaced = "ChenYuluoyan-Thin-Monospaced"
    case Cubic11R = "Cubic_11_R"
    case Huninn = "Huninn"
    case IansuiRegular = "Iansui-Regular"
    case NotoSansTCBlack = "NotoSansTC-Black"
    case NotoSansTCBold = "NotoSansTC-Bold"
    case NotoSansTCExtraBold = "NotoSansTC-ExtraBold"
    case NotoSansTCExtraLight = "NotoSansTC-ExtraLight"
    case NotoSansTCLight = "NotoSansTC-Light"
    case NotoSansTCMedium = "NotoSansTC-Medium"
    case NotoSansTCRegular = "NotoSansTC-Regular"
    case NotoSansTCSemiBold = "NotoSansTC-SemiBold"
    case NotoSansTCThin = "NotoSansTC-Thin"
    case RobotoBlack = "Roboto-Black"
    case RobotoBlackItalic = "Roboto-BlackItalic"
    case RobotoBold = "Roboto-Bold"
    case RobotoBoldItalic = "Roboto-BoldItalic"
    case RobotoItalic = "Roboto-Italic"
    case RobotoLight = "Roboto-Light"
    case RobotoLightItalic = "Roboto-LightItalic"
    case RobotoMedium = "Roboto-Medium"
    case RobotoMediumItalic = "Roboto-MediumItalic"
    case RobotoRegular = "Roboto-Regular"
    case RobotoThin = "Roboto-Thin"
    case RobotoThinItalic = "Roboto-ThinItalic"
}

