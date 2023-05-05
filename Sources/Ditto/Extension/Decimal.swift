import SwiftUI

@available(iOS 15, macOS 12.0, *)
extension Decimal {
    public func ToDouble() -> Double {
        return (self as NSDecimalNumber).doubleValue
    }
    
    public func ToCGFloat() -> CGFloat {
        return CGFloat(self.ToFloat())
    }
    
    public func ToFloat() -> Float {
        return (self as NSDecimalNumber).floatValue
    }
}
