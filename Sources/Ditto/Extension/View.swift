import SwiftUI

@available(iOS 15, *)
extension View {
    @ViewBuilder
    public func foregroundLinearGradient(_ colors: [Color], start: UnitPoint = .topLeading, end: UnitPoint = .trailing) -> some View {
        if colors.count == 0 {
            self
        } else {
            self.overlay {
                LinearGradient(colors: colors, startPoint: start, endPoint: end)
                    .mask { self }
            }
        }
    }
    
    @ViewBuilder
    public func backgroundLinearGradient(_ colors: [Color], start: UnitPoint = .topLeading, end: UnitPoint = .trailing) -> some View {
        if colors.count == 0 {
            self
        } else {
            self.background(
                LinearGradient(colors: colors, startPoint: start, endPoint: end)
            )
        }
    }
}
