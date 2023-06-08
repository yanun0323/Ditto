import SwiftUI

#if os(iOS)
@available(iOS 16, *)
extension UIApplication {
    public func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
