import SwiftUI

extension RangeReplaceableCollection {
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
