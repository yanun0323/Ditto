import SwiftUI

@available(iOS 15, macOS 12.0, *)
public enum ButtonStyle {
    case auto
    case blank
    case linked
}


@available(iOS 15, macOS 12.0, *)
public struct Button<V>: View where V: View {
    @State var width: CGFloat
    @State var height: CGFloat
    @State var color: Color
    @State var radius: CGFloat
    @State var shadow: CGFloat
    var action: () -> Void
    var content: () -> V
    
    public init(
        width: CGFloat,
        height: CGFloat,
        color: Color = .transparent,
        radius: CGFloat = 0,
        shadow: CGFloat = 0,
        action: @escaping () -> Void,
        content: @escaping () -> V
    ) {
        self._width = .init(wrappedValue: width)
        self._height = .init(wrappedValue: height)
        self._color = .init(wrappedValue: color)
        self._radius = .init(wrappedValue: radius)
        self._shadow = .init(wrappedValue: shadow)
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        SwiftUI.Button(action: action){
            if shadow == 0 {
                RoundedRectangle(cornerRadius: radius)
                    .foregroundColor(color)
                    .frame(width: width <= 0 ? nil : width, height: height <= 0 ? nil : height)
                    .overlay(content: content)
            } else {
                RoundedRectangle(cornerRadius: radius)
                    .shadow(radius: shadow)
                    .foregroundColor(color)
                    .frame(width: width <= 0 ? nil : width, height: height <= 0 ? nil : height)
                    .overlay(content: content)
            }
        }
        .buttonStyle(.plain)
    }
}
