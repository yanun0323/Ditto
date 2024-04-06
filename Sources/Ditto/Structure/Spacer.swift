import SwiftUI

struct ConditionSpacer: View {
    @State var visible: Bool
    
    var body: some View {
        if visible {
            SwiftUI.Spacer(minLength: 0)
        } else {
            EmptyView()
        }
    }
}

#if DEBUG
#Preview {
    ConditionSpacer(visible: true)
}
#endif
