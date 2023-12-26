import SwiftUI

extension View {
    @MainActor
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
    
    @MainActor
    @ViewBuilder
    public func expand(width w: CGFloat = 1, height h: CGFloat = 1, alignment a: Alignment = .center) -> some View {
        let safe = Device.safeArea
        self.frame(width: safe.width*deal(w), height: safe.height*deal(h), alignment: a)
    }
    
    private func deal(_ f: CGFloat) -> CGFloat {
        if f > 1 {
            return 1
        }
        
        if f < 0 {
            return 0
        }
        
        return f
    }
    
    @MainActor
    @ViewBuilder
    public func frame(size: CGSize, alignment a: Alignment = .center ) -> some View {
        self.frame(width: size.width, height: size.height, alignment: a)
    }
    
    @MainActor
    @ViewBuilder
    public func frame(maxSize size: CGSize, alignment a: Alignment = .center ) -> some View {
        self.frame(maxWidth: size.width, maxHeight: size.height, alignment: a)
    }
    
    @MainActor
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
    
    @MainActor
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
}

#if os(iOS) || os(macOS) || os(watchOS)
extension View {
    @MainActor
    @ViewBuilder
    public func statusbarArea() -> some View {
        Block(size: Device.statusbarArea)
    }
    
    @MainActor
    @ViewBuilder
    public func homebarArea() -> some View {
        Block(size: Device.homebarArea)
    }
}
#endif

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
