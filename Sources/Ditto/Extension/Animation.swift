import SwiftUI

extension Animation {
    private static var `default` = Animation.easeInOut(duration: 0.1)
    
    public func setDefault(_ a: Animation) {
        Self.default = a
    }
}

extension View {
    public func animation<Value: Equatable>(value v: Value) -> some View {
        self.animation(.default, value: v)
    }
}
