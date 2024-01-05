import SwiftUI

extension Animation {
    public static var `default` = Animation.easeInOut(duration: 0.15)
    
    public func setDefault(_ a: Animation) {
        Self.default = a
    }
}

extension View {
    @MainActor
    @ViewBuilder
    public func animation<Value: Equatable>(value v: Value) -> some View {
        self.animation(.default, value: v)
    }
}
