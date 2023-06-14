import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
extension TimeZone {
    public static let utc = NSTimeZone(name: "UTC")! as TimeZone
}
