import SwiftUI

extension Array {
    public var indexes: Range<Int> { 0 ..< self.count}
    
    public func forEachIndexed(_ body: (Int, Element) throws -> Void) rethrows {
        for i in indexes {
            try body(i, self[i])
        }
    }
    
    public func appended(_ newElement: Element) -> Self {
        var result = self
        result.append(newElement)
        return result
    }
    
    public func appended<S>(contentsOf newElements: S) -> Self where Element == S.Element, S : Sequence {
        var result = self
        result.append(contentsOf: newElements)
        return result
    }
}
