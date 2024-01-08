import SwiftUI

public struct Section<V>: View where V: View {
    @State var title: LocalizedStringKey
    @State var font: Font
    @State var color: Color
    @State var radius: CGFloat
    @State var bg: Color
    @ViewBuilder var content: () -> V
    
    public init(
        _ title: LocalizedStringKey, font: Font = .caption, color: Color = .section,
        radius: CGFloat = 15,
        bg: Color = .section.opacity(0.5), content: @escaping () -> V
    ) {
        self._title = .init(wrappedValue: title)
        self._font = .init(wrappedValue: font)
        self._color = .init(wrappedValue: color)
        self._radius = .init(wrappedValue: radius)
        self._bg = .init(wrappedValue: bg)
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if title != "" {
                Text(title)
                    .font(font)
                    .foregrounds(color)
                    .padding(.leading, 5)
            }
            content()
                .backgrounds(bg)
                .cornerRadius(radius)
        }
    }
}

#if DEBUG
#Preview {
    Section("123", bg: .section) {
        Text("Hello")
            .padding()
    }
    .padding()
}
#endif
