import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(watchOS)
public struct Device {
    public let screen: CGSize
    public let homebarArea: CGSize
    public let statusbarArea: CGSize
    public let safeArea: CGSize
    
    init() {
        self.screen = Device.screen
        self.homebarArea = Device.homebarArea
        self.statusbarArea = Device.statusbarArea
        self.safeArea = Device.safeArea
    }
}

extension Device {
    public static let safeArea: CGSize = safeAreaInsets.screenSize
    public static let homebarArea: CGSize = CGSize(width: screen.width, height: safeAreaInsets.bottom)
    public static let statusbarArea: CGSize = CGSize(width: screen.width, height: safeAreaInsets.top)
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
    public static let screen: CGSize = WKInterfaceDevice.current().screenBounds.screenSize
    public static let safeAreaInsets: EdgeInsets = .init()}
#elseif os(iOS)
extension Device {
    public static let screen: CGSize = UIScreen.main.bounds.size
    public static let safeAreaInsets: EdgeInsets = UIApplication.shared.rootWindow?.safeAreaInsets.insets ?? .init()
}

extension UIEdgeInsets {
    public var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

extension UIApplication {
    public var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
    
    
    public var rootWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first
    }
}
#elseif os(macOS)
extension Device {
    public static let screen: CGSize = NSScreen.main?.visibleFrame.screenSize ?? .zero // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
    public static let safeAreaInsets: EdgeInsets = NSScreen.main?.safeAreaInsets.insets ?? .init()
}

extension NSEdgeInsets {
    public var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
#endif
