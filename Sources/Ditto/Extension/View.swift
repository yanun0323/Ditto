import SwiftUI

extension View {
    // MARK: debug
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
    
    // MARK: expand
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
    
    // MARK: frame
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
    
    // MARK: round
    @MainActor
    @ViewBuilder
    public func round(radius: CGFloat = 7) -> some View {
        if radius == 0 {
            self
        } else {
            self.clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
    
    // MARK: shadow
    @MainActor
    @ViewBuilder
    public func shadow(expand: CGFloat = 15) -> some View {
        self.shadow(color: .black.opacity(0.3), radius: expand, y: expand*0.3)
    }
    
    // MARK: paddings
    @MainActor
    @ViewBuilder
    public func paddings(_ edges: CGFloat...) -> some View {
        paddings(edges)
    }
    
    @MainActor
    @ViewBuilder
    public func paddings(_ edges: [CGFloat]) -> some View {
        switch edges.count {
        case 0:
            self.padding()
        case 1:
            self.padding(edges[0])
        case 2:
            self
                .padding(.vertical, edges[0])
                .padding(.horizontal, edges[1])
        case 4:
            self
                .padding(.top, edges[0])
                .padding(.trailing, edges[1])
                .padding(.bottom, edges[2])
                .padding(.leading, edges[3])
        default:
            self
        }
    }
    
    // MARK: foregrounds
    @MainActor
    @ViewBuilder
    public func foregrounds(_ colors: Color...) -> some View {
        foregrounds(colors)
    }
    
    @MainActor
    @ViewBuilder
    public func foregrounds(_ colors: [Color]) -> some View {
        switch colors.count {
        case 0:
            if #available(iOS 17, macOS 14, watchOS 10, *) {
                self.foregroundStyle(.primary)
            } else {
                self.foregroundColor(.primary)
            }
        case 1:
            if #available(iOS 17, macOS 14, watchOS 10, *) {
                self.foregroundStyle(colors[0])
            } else {
                self.foregroundColor(colors[0])
            }
        default:
            if #available(iOS 17, macOS 14, watchOS 10, *) {
                self
                    .foregroundStyle(.clear)
                    .overlay {
                        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .trailing)
                            .mask { self }
                    }
            } else {
                self
                    .foregroundColor(.clear)
                    .overlay {
                        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .trailing)
                            .mask { self }
                    }
            }
        }
    }
    
    
    // MARK: backgrounds
    @MainActor
    @ViewBuilder
    public func backgrounds(_ colors: Color...) -> some View {
        backgrounds(colors)
    }
    
    @MainActor
    @ViewBuilder
    public func backgrounds(_ colors: [Color]) -> some View {
        switch colors.count {
        case 0:
            self.background()
        case 1:
            self.background(colors[0])
        default:
            self.background(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .trailing)
            )
        }
    }
}

// MARK: statusbar
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
#Preview {
    VStack {
        Text("Hello, world!")
            .font(.largeTitle)
            .foregrounds(.red, .purple)
        Text("Hello, world!")
            .font(.largeTitle)
            .backgrounds(.red, .purple)
        Text("Empty Background")
            .backgrounds()
    }
}
#endif
