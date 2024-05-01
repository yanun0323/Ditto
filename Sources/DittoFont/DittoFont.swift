import Foundation
import SwiftUI

public class DittoFont {
    public static func registerFonts(_ fonts: DittoFont.Font...) {
        DittoFont.registerFonts(fonts)
    }
    
    public static func registerFonts(_ fonts: [DittoFont.Font]) {
        fonts.forEach {
            registerFont(bundle: .module, fontName: $0.filename, fontExtension: "ttf")
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
            print("font \(font.fullName.string) registered")
        } else {
            fatalError("font \(fontName) register failed")
        }
    }
}

fileprivate extension CFString? {
    var string: String {
        if let s = self {
            return "\(s)"
        }
        
        return "-"
    }
}

