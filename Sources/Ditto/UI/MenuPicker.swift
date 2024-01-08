import SwiftUI

public struct MenuPicker<Content, Label, SelectionValue>: View where Content: View, Label: View, SelectionValue: Hashable {
    @Binding var selection: SelectionValue
    @ViewBuilder var content: () -> Content
    @ViewBuilder var label: () -> Label
    
    public init(selection: Binding<SelectionValue>, content: @escaping () -> Content, label: @escaping () -> Label) {
        self._selection = selection
        self.content = content
        self.label = label
    }
    
    public var body: some View {
        ZStack {
            label()
            Menu {
                Picker(selection: $selection) {
                    content()
                } label: {}.pickerStyle(.inline)
            } label: {
                Rectangle()
            }
            .menuStyle(.borderlessButton)
        }
    }
}

#if DEBUG
#Preview {
    @State var selection = 1
    return MenuPicker(selection: $selection) {
        ForEach(1...10, id: \.self) { i in
            Text(i.description).tag(i)
        }
    } label: {
        Text(selection.description)
    }
}
#endif
