import SwiftUI

extension View {
    @ViewBuilder
    public func spinning(frame size: CGFloat, speed: CGFloat = 1.2) -> some View {
        Loading(icon: self, frame: size, speed: speed)
    }
}

public struct Loading<Content: View>: View {
    @State private var isLoading = false
    @State private var frame: CGFloat
    @State private var speed: CGFloat
    private let icon: Content
    
    var lineWidth: CGFloat { frame*0.15 }
    
    public var body: some View {
        spine()
    }
    
    public init(icon: Content = Circle(), frame: CGFloat = 50, speed: CGFloat = 1.2) {
        self._frame = .init(wrappedValue: frame)
        self._speed = .init(wrappedValue: speed)
        self.icon = icon
    }
    
    @MainActor
    @ViewBuilder
    private func spine() -> some View {
        let count = 4
        ZStack {
            ForEach(0...(count-1), id: \.self) { i in
                let opacity = 1 - CGFloat(i)/CGFloat(count)
                let diameter = lineWidth
                icon
                    .frame(width: diameter, height: diameter)
                    .opacity(opacity)
                    .offset(y: -(frame-lineWidth-lineWidth+diameter)*0.5)
                    .rotationEffect(Angle(degrees:-Double(i)*40))
                    .rotationEffect(Angle(degrees:isLoading ? 360 : 0))
                    .animation(.linear(duration: speed).repeatForever(autoreverses: false), value: isLoading)
                    .onAppear { isLoading = true }
                    .transition(.opacity)
            }
        }
        .frame(width: frame, height: frame)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 50) {
        Loading()
        Loading(frame: 80)
        Loading(icon: Image(systemName: "applelogo"), frame: 100)
        Circle()
            .spinning(frame: 50, speed: 1)
        Rectangle()
            .spinning(frame: 80, speed: 1.5)
    }
}
#endif
