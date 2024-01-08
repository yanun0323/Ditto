import SwiftUI

public struct Button<V>: View where V: View {
    @State var width: CGFloat
    @State var height: CGFloat
    @State var colors: [Color]
    @State var radius: CGFloat
    @ViewBuilder var action: () -> Void
    @ViewBuilder var content: () -> V
    
    public init(
        width: CGFloat,
        height: CGFloat,
        color: [Color],
        radius: CGFloat = 0,
        action: @escaping () -> Void,
        content: @escaping () -> V
    ) {
        self._width = .init(wrappedValue: width)
        self._height = .init(wrappedValue: height)
        self._colors = .init(wrappedValue: color.count == 0 ? [.transparent] : color)
        self._radius = .init(wrappedValue: radius)
        self.action = action
        self.content = content
    }
    
    
    public init(
        width: CGFloat,
        height: CGFloat,
        color: Color...,
        radius: CGFloat = 0,
        action: @escaping () -> Void,
        content: @escaping () -> V
    ) {
        self.init(width: width, height: height, color: color, radius: radius, action: action, content: content)
    }
    
    public var body: some View {
        SwiftUI.Button(action: action){
            Rectangle()
                .foregrounds(.transparent)
                .backgrounds(colors)
                .frame(width: width <= 0 ? nil : width, height: height <= 0 ? nil : height)
                .overlay(content: content)
        }
        .buttonStyle(.plain)
        .round(radius)
    }
}

#if DEBUG
#Preview {
    VStack {
        Button(width: 50, height: 50, color: .white, .ivory, radius: 30) {
            
        } content: {
            Image(systemName: "plus")
                .font(.system(size: 25))
                .foregrounds()
        }
        .shadow(radius: 5)
        
        Rectangle()
            .frame(width: 50, height: 50)
    }
    .padding()
    .backgrounds(Color.red)
}
#endif
