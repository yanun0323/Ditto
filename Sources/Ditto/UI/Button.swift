import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
public struct Button<V>: View where V: View {
    @State var width: CGFloat
    @State var height: CGFloat
    @State var colors: [Color]
    @State var radius: CGFloat
    var action: () -> Void
    var content: () -> V
    
    public init(
        width: CGFloat,
        height: CGFloat,
        colors: [Color],
        radius: CGFloat = 0,
        action: @escaping () -> Void,
        content: @escaping () -> V
    ) {
        self._width = .init(wrappedValue: width)
        self._height = .init(wrappedValue: height)
        self._colors = .init(wrappedValue: colors)
        self._radius = .init(wrappedValue: radius)
        self.action = action
        self.content = content
    }
    
    
    public init(
        width: CGFloat,
        height: CGFloat,
        color: Color = .transparent,
        radius: CGFloat = 0,
        action: @escaping () -> Void,
        content: @escaping () -> V
    ) {
        self.init(width: width, height: height, colors: [color], radius: radius, action: action, content: content)
    }
    
    public var body: some View {
        SwiftUI.Button(action: action){
            Rectangle()
                .foregroundColor(.transparent)
                .backgroundLinearGradient(colors)
                .frame(width: width <= 0 ? nil : width, height: height <= 0 ? nil : height)
                .overlay(content: content)
        }
        .buttonStyle(.plain)
        .cornerRadius(radius)
    }
}

#if DEBUG
struct Button_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(width: 50, height: 50, color: .white, radius: 30) {
                
            } content: {
                Image(systemName: "plus")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }
            .shadow(radius: 5)
            
            Rectangle()
                .frame(width: 50, height: 50)
        }
        .padding()
        .background(Color.red)
    }
}
#endif
