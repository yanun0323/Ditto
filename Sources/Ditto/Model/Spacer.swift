import SwiftUI

struct ConditionSpacer: View {
    @State var visible: Bool
    
    var body: some View {
        if visible {
            SwiftUI.Spacer()
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
