import SwiftUI

extension View {
    // MARK: pixel
    @MainActor 
    public func pixel(size: CGFloat? = nil, weight: Font.Weight = .regular
    ) -> some View {
        #if os(macOS)
        let size = size ?? 13
        #else
        let size = size ?? 17
        #endif
        return self.font(.system(size: size*10, weight: weight))
            .mosaic(9)
            .scale(0.1)
            .frame(width: size, height: size)
    }
    
    // MARK: scale
    public func scale(_ size: CGFloat, anchor: UnitPoint = .center) -> some View {
        self.scaleEffect(CGSize(width: size, height: size), anchor: anchor)
    }
    
    // MARK: rotate
    public func rotate(_ degrees: CGFloat, anchor: UnitPoint = .center) -> some View {
        self.rotationEffect(Angle(degrees: degrees), anchor: anchor)
    }
    
    // MARK: debug
    public func debug(_ color: Color = .red, cover expected: CGSize? = nil) -> some View {
        ZStack {
        #if DEBUG
                if expected != nil {
                    self
                    VStack {}
                        .frame(size: expected!).border(color, width: 1)
                    
                } else {
                    self.border(color, width: 1)
                }
        #else
                self
        #endif
            }
    }
    
    // MARK: expand
    public func expand(width w: CGFloat = 1, height h: CGFloat = 1, alignment a: Alignment = .center) -> some View {
        self.frame(width: Device.safeArea.width*deal(w), height: Device.safeArea.height*deal(h), alignment: a)
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
    public func frame(_ edges: CGFloat..., alignment a: Alignment = .center) -> some View {
        switch edges.count {
        case 1:
            self.frame(width: edges[0], height: edges[0], alignment: a)
        case 2:
            self.frame(width: edges[1], height: edges[0], alignment: a)
        default:
            self.frame(width: nil, height: nil, alignment: a)
        }
    }
    
    public func frame(max edges: CGFloat..., alignment a: Alignment = .center) -> some View {
        switch edges.count {
        case 1:
            self.frame(maxWidth: edges[0], maxHeight: edges[0], alignment: a)
        case 2:
            self.frame(maxWidth: edges[1], maxHeight: edges[0], alignment: a)
        default:
            self.frame(maxWidth: nil, maxHeight: nil, alignment: a)
        }
    }
    
    public func frame(size: CGSize, alignment a: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height, alignment: a)
    }
    
    public func frame(maxSize size: CGSize, alignment a: Alignment = .center ) -> some View {
        self.frame(maxWidth: size.width, maxHeight: size.height, alignment: a)
    }
    
    // MARK: round
    public func round(_ radius: CGFloat = 13) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
    
    // MARK: shadow
    public func shadow(expand: CGFloat = 15) -> some View {
        self.shadow(color: .shadow, radius: expand, y: expand*0.3)
    }
    
    // MARK: paddings
    public func paddings(_ edges: CGFloat...) -> some View {
        self.paddings(edges)
    }
    
    public func paddings(_ edges: [CGFloat]) -> some View {
        Group {
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
                self.padding(0)
            }
        }
    }
    
    // MARK: foregrounds
    public func foregrounds(_ colors: Color...) -> some View {
        self.foregrounds(colors)
    }
    
    public func foregrounds(_ colors: [Color]) -> some View {
        Group {
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
    }
    
    
    // MARK: backgrounds
    public func backgrounds(_ colors: Color...) -> some View {
        self.backgrounds(colors)
    }
    
    public func backgrounds(_ colors: [Color]) -> some View {
        Group {
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
    
    // MARK: date picker
    public func datePicker(
        selection date: Binding<Date>,
        in range: ClosedRange<Date>,
        displayed style: DatePickerComponents = .date,
        debug: Bool = false
    ) -> some View {
        self.overlay {
            DatePicker(selection: date, in: range, displayedComponents: style, label: {})
                .labelsHidden()
                .datePickerStyle(.compact)
                .opacity(debug ? 0.8 : 0.011)
        }
    }
    
    public func datePicker(
        selection date: Binding<Date>,
        in range: PartialRangeFrom<Date>,
        displayed style: DatePickerComponents = .date,
        debug: Bool = false
    ) -> some View {
        self.overlay {
            DatePicker(selection: date, in: range, displayedComponents: style, label: {})
                .labelsHidden()
                .datePickerStyle(.compact)
                .opacity(debug ? 0.8 : 0.011)
        }
    }
}

// MARK: statusbar
#if os(iOS) || os(macOS) || os(watchOS)
extension View {
    public func statusbarArea() -> some View {
        Block(size: Device.statusbarArea)
    }
    
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
            .paddings(5, 15)
            .round()
            .contextMenu {
                Button("123") {}
            }
            .opacity(0.3)
            .datePicker(selection: .constant(.now), in: Date(2024,1,1,0,0,0)...Date.now, displayed: .date, debug: true)
        Text("Empty Background")
            .backgrounds()
        
            
        Text("Text Menu")
            .font(.largeTitle)
            .paddings(5, 15)
            .backgrounds(.red, .purple)
            .round()
            .contextMenu {
                Button("123") {}
            }
            .padding(.bottom)
        
        Text(Date.now.description)
        Text(Date.now.string())
            .padding(.bottom)
        
        Text(Date.now.replace(hour: 0, minute: 0, second: 0).description)
        Text(Date.now.replace(hour: 0, minute: 0, second: 0).string())
            .padding(.bottom)
    }
    .padding()
}
#endif
