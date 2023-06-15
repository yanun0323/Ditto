import SwiftUI

extension Loading {
    public enum Style {
        case spine, circle
    }
}

public struct Loading: View {
    @State private var isLoading = false
    public var style: Style
    public var color: Color
    public var size: CGFloat
    public var lineWidth: CGFloat
    public var speed: Double
    public var action: (() -> Bool)?
    
    public var body: some View {
        build()
    }
    
    public init(style: Style = .spine, color: Color = .section, size: CGFloat = 50, lineWidth: CGFloat = 7, speed: Double = 1.2, action: (() -> Bool)? = nil) {
        self.style = style
        self.color = color
        self.size = size
        self.lineWidth = lineWidth
        self.speed = speed
        self.action = action
    }
    
    @ViewBuilder
    private func build() -> some View {
        switch style {
            case .spine:
                spine()
            case .circle:
                circle()
        }
    }
    
    @ViewBuilder
    private func spine() -> some View {
        let count = 4
        ZStack {
            ForEach(0...(count-1), id: \.self) { i in
                let ratio = 1 - Double(i)*0.1
                let diameter = lineWidth*ratio
                Circle()
                    .foregroundColor(color)
                    .frame(width: diameter, height: diameter)
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
