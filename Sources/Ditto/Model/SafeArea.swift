import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(watchOS)
public struct Device {
    public var screen: CGSize { Device.screen }
    public var homebarArea: CGSize { Device.homebarArea }
    public var statusbarArea: CGSize { Device.statusbarArea }
    public var safeArea: CGSize { Device.safeArea }
}

extension Device {
    public static var safeArea: CGSize { safeAreaInsets.screenSize }
    public static var homebarArea: CGSize { CGSize(width: screen.width, height: safeAreaInsets.bottom) }
    public static var statusbarArea: CGSize { CGSize(width: screen.width, height: safeAreaInsets.top) }
}

public extension EdgeInsets {
    /**
     return the CGSize associated to unsafe area
     */
    var screenSize: CGSize {
        CGSize(width: Device.screen.width - leading - trailing,
               height: Device.screen.height - top - bottom)
    }
}
#endif

#if os(watchOS)
extension Device {
    public static var screen: CGSize { WKInterfaceDevice.current().screenBounds.screenSize }
    public static var safeAreaInsets: EdgeInsets { .init() }
}
#elseif os(iOS)
extension Device {
    public static var screen: CGSize { UIScreen.main.bounds.size }
    public static var safeAreaInsets: EdgeInsets { UIApplication.shared.rootWindow?.safeAreaInsets.insets ?? .init() }
}

extension UIEdgeInsets {
    public var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

extension UIApplication {
    public var rootWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first
    }
}
#elseif os(macOS)
extension Device {
    public static var screen: CGSize { NSScreen.main?.visibleFrame.screenSize ?? .zero } // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
    public static var safeAreaInsets: EdgeInsets { NSScreen.main?.safeAreaInsets.insets ?? .init() }
}

extension NSEdgeInsets {
    public var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
#endif

#if DEBUG
struct SafeAreaTestView: View {
    var body: some View {
        SwiftUI.Button("print parameter") {
            print("\(Device.safeArea)")
            print("\(Device.statusbarArea)")
            print("\(Device.homebarArea)")
        }
    }
}

#Preview {
    SafeAreaTestView()
}
#endif
