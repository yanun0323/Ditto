import SwiftUI

public struct Debug {}

extension Debug {
    public static func print(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n"
    ) {
        #if DEBUG
        Swift.print(items, separator: separator, terminator: terminator)
        #endif
    }
}
/**
 prints content with the building tag  **`#if DEBUG`**
 */
public func printDebug(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n"
) {
    Debug.print(items, separator: separator, terminator: terminator)
}
