import SwiftUI

extension View {
    public func makeLoading(frame size: CGFloat, speed: CGFloat = 1.2, fixed: Bool = false) -> some View {
        Loading(icon: self, frame: size, speed: speed, fixed: fixed)
    }
}

public struct Loading<Content: View>: View {
    @State private var isLoading = false
    @State private var frame: CGFloat
    @State private var speed: CGFloat
    @State private var fixed: Bool
    private let icon: Content
    
    var lineWidth: CGFloat { frame*0.15 }
    
    public var body: some View {
        spine()
    }
    
    public init(icon: Content = Circle(), frame: CGFloat = 50, speed: CGFloat = 1.2, fixed: Bool = false) {
        self._frame = .init(wrappedValue: frame)
        self._speed = .init(wrappedValue: speed)
        self._fixed = .init(wrappedValue: fixed)
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
                    .rotate(fixed ? Double(i)*40 : 0)
                    .rotate(fixed && isLoading ? 0 : 360)
                    .frame(width: diameter, height: diameter)
                    .opacity(opacity)
                    .offset(y: -(frame-lineWidth-lineWidth+diameter)*0.5)
                    .rotate(-Double(i)*40)
                    .rotate(isLoading ? 360 : 0)
                    .animation(.linear(duration: speed).repeatForever(autoreverses: false), value: isLoading)
                    .onAppear {
                        System.async {
                            withAnimation {
                                isLoading = true
                            }
                        } main: {}
                    }
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
        Loading(icon: Image(systemName: "applelogo"), frame: 100, fixed: true)
        Circle()
            .makeLoading(frame: 50, speed: 1)
        Rectangle()
            .makeLoading(frame: 80, speed: 1.5)
        Rectangle()
            .makeLoading(frame: 80, speed: 1.5, fixed: true)
    }
}
#endif
