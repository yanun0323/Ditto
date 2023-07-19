import SwiftUI

public struct Debug {}

extension Debug {
    public static func print(_ message: String) {
        #if DEBUG
        Swift.print(message)
        #endif
    }
    
    public static func print(_ error: Error) {
        #if DEBUG
        Swift.print(String(describing: error))
        #endif
    }
}
