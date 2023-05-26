import SwiftUI

@available(iOS 15, *)
extension View {
    public func foregroundLinearGradient(_ colors: [Color], start: UnitPoint = .topLeading, end: UnitPoint = .trailing, blur: CGFloat = 0) -> some View {
        return self.overlay {
            LinearGradient(colors: colors, startPoint: start, endPoint: end)
                .blur(radius: blur)
                .mask { self }
        }
    }
    
    public func backgroundLinearGradient(_ colors: [Color], start: UnitPoint = .topLeading, end: UnitPoint = .trailing, blur: CGFloat = 0) -> some View {
        return self.background(
            LinearGradient(colors: colors, startPoint: start, endPoint: end)
                .blur(radius: blur)
        )
    }
}
