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
                    selection = i
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
struct TabPicker_Previews: PreviewProvider {
    @State static var selected = 0
    
    static var previews: some View {
        VStack {
            TabPickerTest(items: [
                TabPickerItem(image: "trash"),
                TabPickerItem(image: "trash.fill")
            ])
            .warning()
            .frame(size: CGSize(width: 300, height: 50))
            
            TabPickerTest(size: 30, color: .primary, items: [
                TabPickerItem(image: "trash"),
                TabPickerItem(image: "trash.fill")
            ])
            .warning()
            .frame(size: CGSize(width: 300, height: 50))
        }
    }
}

struct TabPickerTest: View {
    @State private var selected: Int = 0
    @State var size: CGFloat = 22
    @State var color: Color = .accentColor
    @State var items: [TabPickerItem]
    var body: some View {
        TabPicker(selection: $selected, size: size, color: color, items: items)
    }
}
#endif
