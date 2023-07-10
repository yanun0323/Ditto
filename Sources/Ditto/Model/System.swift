import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@available(iOS 16, macOS 13, watchOS 9, *)
public struct System {
    public static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    public static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
}

@available(iOS 16, macOS 13, watchOS 9, *)
extension System {
    /**
     # async
     Invoke function in background thread and main thread
     */
    public static func async(background: @escaping () -> Void = {}, main: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
            DispatchQueue.main.async {
                main()
            }
        }
    }
    
    public static func async<T>(background: @escaping () -> T = {}, main: @escaping (T) -> Void) {
        DispatchQueue.global().async {
            let data = background()
            DispatchQueue.main.async {
                main(data)
            }
        }
    }
}

@available(iOS 16, macOS 13, watchOS 9, *)
extension System {
    public static func doCatch<T>(_ log: String, _ action: () throws -> T?) -> T? where T: Any {
        do {
            return try action()
        } catch {
            print("[ERROR] \(log), err: \(error)")
        }
        return nil
    }
}

#if os(macOS)
@available(macOS 13, *)
extension System {
    public static func unfocus() {
        NSApp.keyWindow?.makeFirstResponder(nil)
    }
}
#endif

@available(iOS 16, macOS 13, watchOS 9, *)
extension System {
#if os(watchOS)
    public static let screen: CGSize = WKInterfaceDevice.current().screenBounds.size
#elseif os(iOS)
    public static let screen: CGSize = UIScreen.main.bounds.size
#elseif os(macOS)
    public static let screen: CGSize = NSScreen.main?.visibleFrame.size ?? .zero // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
#endif
    /*** deprecated, use `System.screen.x(0.5).width` instead */
    public static func screen(_ d: Dimension, _ ratio: CGFloat) -> CGFloat {
        if d == .width {
            return screen.width * ratio
        }
        return screen.height * ratio
    }
    public enum Dimension {
        case width, height
    }
}
