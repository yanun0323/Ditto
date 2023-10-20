import SwiftUI

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
