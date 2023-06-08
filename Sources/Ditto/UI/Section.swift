import SwiftUI

@available(iOS 16, macOS 13.0, *)
public struct Section<V>: View where V: View {
    var title: LocalizedStringKey
    var font: Font
    var color: Color
    var radius: CGFloat
    var bg: Color
    var content: () -> V
    
    public init(
        _ title: LocalizedStringKey, font: Font = .caption, color: Color = .section,
        radius: CGFloat = 15,
        bg: Color = .section.opacity(0.5), content: @escaping () -> V
    ) {
        self.title = title
        self.font = font
        self.color = color
        self.radius = radius
        self.bg = bg
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if title != "" {
                Text(title)
                    .font(font)
                    .foregroundColor(color)
                    .padding(.leading, 5)
            }
            content()
                .background(bg)
                .cornerRadius(radius)
        }
    }
}

#if DEBUG
struct Section_Previews: PreviewProvider {
    static var previews: some View {
        Section("123") {
            Text("Hello")
        }
    }
}
#endif
