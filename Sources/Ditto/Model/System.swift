import SwiftUI


@available(macOS 12.0, iOS 15, *)
public struct System {
    public static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    public static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
}

@available(macOS 12.0, iOS 15, *)
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

@available(macOS 12.0, iOS 15, *)
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
import AppKit

@available(macOS 12.0, *)
extension System {
    public static func unfocus() {
        NSApp.keyWindow?.makeFirstResponder(nil)
    }
}
#endif



#if os(iOS)
import UIKit

@available(iOS 15, *)
extension System {
    public static let device: Device = .init()
}

public struct Device {
    public let screen: CGRect = UIScreen.main.bounds
}
#endif
