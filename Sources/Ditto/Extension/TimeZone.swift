import SwiftUI

@available(iOS 15, macOS 12.0, *)
extension TimeZone {
    public static let utc = NSTimeZone(name: "UTC")! as TimeZone
}
