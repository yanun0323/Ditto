import SwiftUI

extension Array {
    public var indexes: Range<Int> { 0 ..< self.count}
    
    public func forEach(_ body: (Int, Element) throws -> Void) rethrows {
        for i in indexes {
            try body(i, self[i])
        }
    }
}
