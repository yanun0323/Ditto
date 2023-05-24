import SwiftUI

@available(iOS 15, macOS 12.0, *)
public enum Direction {
    case horizontal
    case vertical
}

@available(iOS 15, macOS 12.0, *)
public struct Separator: View {
    @State var direction: Direction
    @State var color: Color
    @State var size: CGFloat
    
    public init(
        direction: Direction = .horizontal,
        color: Color = .gray,
        size: CGFloat = 1
    ) {
        self._direction = .init(wrappedValue: direction)
        self._color = .init(wrappedValue: color)
        self._size = .init(wrappedValue: size)
    }
    
    public var body: some View {
        Rectangle()
            .foregroundColor(color)
            .frame(width: width, height: height)
    }
}

// MARK: Private Property
@available(iOS 15, macOS 12.0, *)
extension Separator {
    private var width: CGFloat? {
        return direction == .horizontal ? nil : safeSize
    }
    
    private var height: CGFloat? {
        return direction == .vertical ? nil : safeSize
    }
    
    private var safeSize: CGFloat? {
        return size <= 0 ? nil : size
    }
}
