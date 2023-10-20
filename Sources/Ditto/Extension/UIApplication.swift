import SwiftUI

#if os(iOS)
extension UIApplication {
    public func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
