import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
extension View {
    @ViewBuilder
    public func debug() -> some View {
        self.border(Color.red, width: 1)
    }
    
    @ViewBuilder
    public func frame(size: CGSize, alignment a: Alignment = .center ) -> some View {
        self.frame(width: size.width, height: size.height, alignment: a)
    }
    
    @ViewBuilder
    public func frame(maxSize size: CGSize, alignment a: Alignment = .center ) -> some View {
        self.frame(maxWidth: size.width, maxHeight: size.height, alignment: a)
    }
    
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
