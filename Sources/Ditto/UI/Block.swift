import SwiftUI

@available(iOS 16, macOS 13.0, *)
public struct Block: View {
    @State var width: CGFloat
    @State var height: CGFloat
    @State var color: Color
    
    public init(width: CGFloat = -1, height: CGFloat = -1, color: Color = .clear) {
        self._width = .init(wrappedValue: width)
        self._height = .init(wrappedValue: height)
        self._color = .init(wrappedValue: color)
    }
    
    public var body: some View {
        Rectangle()
            .foregroundColor(color)
            .frame(width: width <= 0 ? nil : width, height: height <= 0 ? nil : height)
    }
}
