import SwiftUI

public struct TabPickerItem: Identifiable {
    public var id: String { self.image }
    public var image: String
    
    public init(image: String) {
        self.image = image
    }
}

public struct TabPicker: View {
    @Binding var selection: Int
    @State var size: CGFloat
    @State var color: Color
    @State var items: [TabPickerItem]
    
    public init(selection: Binding<Int>, size: CGFloat = CGFloat(22), color: Color = Color.accentColor, items: [TabPickerItem]) {
        self._selection = selection
        self._size = State(initialValue: size)
        self._color = State(initialValue: color)
        self._items = State(initialValue: items)
    }
    
    public init(selection: Binding<Int>, size: CGFloat = CGFloat(22), color: Color = Color.accentColor, items: TabPickerItem...) {
        self._selection = selection
        self._size = State(initialValue: size)
        self._color = State(initialValue: color)
        self._items = State(initialValue: items)
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0 ..< items.count, id: \.self) { i in
                Button {
                    _selection.wrappedValue = i
                } label: {
                    Image(systemName: items[i].image)
                        .frame(width: size, height: size)
                        .font(.system(size: size*0.8))
                        .foregrounds(i == selection ? color : color.opacity(0.25))
                }
                .tag(i)

                Spacer()
            }
        }
    }
}

#if DEBUG
#Preview {
    @State var selected: Int = 0
    var b: Binding<Int> = Binding {
        return selected
    } set: { val in
        selected = val
    }

    return VStack {
        TabPicker(selection: b, items: [
            TabPickerItem(image: "trash"),
            TabPickerItem(image: "trash.fill")
        ])
        .debug()
        .frame(size: CGSize(width: 300, height: 50))
        
        TabPicker(selection: b, size: 30, color: .primary, items: [
            TabPickerItem(image: "trash"),
            TabPickerItem(image: "trash.fill")
        ])
        .debug()
        .frame(size: CGSize(width: 300, height: 50))
    }
}
#endif
