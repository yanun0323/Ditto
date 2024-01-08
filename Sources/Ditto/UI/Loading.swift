import SwiftUI

extension Loading {
    public enum Style {
        case spine, circle
    }
}

public struct Loading: View {
    @State private var isLoading = false
    @State public var style: Style
    @State public var color: Color
    @State public var size: CGFloat
    @State public var lineWidth: CGFloat
    @State public var speed: Double
    @State public var action: (() -> Bool)?
    
    public var body: some View {
        build()
    }
    
    public init(style: Style = .spine, color: Color = .section, size: CGFloat = 50, lineWidth: CGFloat = 7, speed: Double = 1.2, action: (() -> Bool)? = nil) {
        self._style = .init(wrappedValue: style)
        self._color = .init(wrappedValue: color)
        self._size = .init(wrappedValue: size)
        self._lineWidth = .init(wrappedValue: lineWidth)
        self._speed = .init(wrappedValue: speed)
        self.action = action
    }
    
    @MainActor
    @ViewBuilder
    private func build() -> some View {
        switch style {
            case .spine:
                spine()
            case .circle:
                circle()
        }
    }
    
    @MainActor
    @ViewBuilder
    private func spine() -> some View {
        let count = 4
        ZStack {
            ForEach(0...(count-1), id: \.self) { i in
                let opacity = 1 - CGFloat(i)/CGFloat(count)
                let diameter = lineWidth
                Circle()
                    .foregrounds(color)
                    .frame(width: diameter, height: diameter)
                    .opacity(opacity)
                    .offset(y: -(size-lineWidth-lineWidth+diameter)*0.5)
                    .rotationEffect(Angle(degrees:-Double(i)*40))
                    .rotationEffect(Angle(degrees:isLoading ? 360 : 0))
                    .animation(.linear(duration: speed).repeatForever(autoreverses: false), value: isLoading)
                    .onAppear { isLoading = true }
                    .transition(.opacity)
            }
        }
        .frame(width: size, height: size)
    }
    
    @MainActor
    @ViewBuilder
    private func circle() -> some View {
        VStack {
            let diameter = size - lineWidth
            Circle()
                .trim(from: 0, to: 0.65)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth))
                .frame(width: diameter, height: diameter)
                .rotationEffect(Angle(degrees:isLoading ? 360 : 0))
                .animation(.linear(duration: speed).repeatForever(autoreverses: false), value: isLoading)
                .onAppear { isLoading = true }
                .transition(.opacity)
        }
        .frame(width: size, height: size)
    }
    
}

struct DownloadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            Loading()
            Loading(style: .circle)
        }
    }
}
