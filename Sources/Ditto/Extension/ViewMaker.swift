import SwiftUI

extension View {
    public func makeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
    }
}
