import SwiftUI

/**
 Room provides various screen size properties. e.g. device size, statusbar area size, homebar area size...
 */
@available(iOS 16, macOS 13, watchOS 9, *)
public struct Room {
    public static let device = System.screen
    public static let statusbar = CGSize(width: device.width, height: 60)
    public static let container = CGSize(width: device.width, height: device.height - statusbar.height - homebar.height)
    public static let homebar = CGSize(width: device.width, height: 40)
}
