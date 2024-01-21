import SwiftUI

extension View {
    @ViewBuilder
    public func makeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
    }
}
