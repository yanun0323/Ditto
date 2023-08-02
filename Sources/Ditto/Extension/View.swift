import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
extension View {
    @ViewBuilder
    public func debug(_ color: Color = .red, cover expected: CGSize? = nil) -> some View {
    #if DEBUG
        if expected != nil {
            ZStack {
                self
                VStack {}
                    .frame(size: expected!).border(color, width: 1)
            }
        } else {
            self.border(color, width: 1)
        }
    #else
        self
    #endif
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
    public func foregroundGradient(_ colors: [Color], start: UnitPoint = .topLeading, end: UnitPoint = .trailing) -> some View {
        if colors.count == 0 {
            self
        } else {
            self
                .foregroundColor(.clear)
                .overlay {
                LinearGradient(colors: colors, startPoint: start, endPoint: end)
                    .mask { self }
            }
        }
    }
    
    @ViewBuilder
    public func backgroundGradient(_ colors: [Color], start: UnitPoint = .topLeading, end: UnitPoint = .trailing) -> some View {
        if colors.count == 0 {
            self
        } else {
            self.background(
                LinearGradient(colors: colors, startPoint: start, endPoint: end)
            )
        }
    }
    
    @ViewBuilder
    public func statusbarArea() -> some View {
        Block(size: .statusbar)
    }
    
    @ViewBuilder
    public func homebarArea() -> some View {
        Block(size: .homebar)
    }
}

#if DEBUG
struct Gradient_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello, world!")
                .font(.largeTitle)
                .foregroundGradient([.red, .purple])
            Text("Hello, world!")
                .font(.largeTitle)
                .backgroundGradient([.red, .purple])
        }
    }
}
#endif
