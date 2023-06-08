import SwiftUI

@available(iOS 16, macOS 13.0, *)
extension Decimal {
    public var double: Double {
        return (self as NSDecimalNumber).doubleValue
    }
    
    public var cgfloat: CGFloat {
        return CGFloat(self.float)
    }
    
    public var float: Float {
        return (self as NSDecimalNumber).floatValue
    }
}
