import SwiftUI

public struct TabPicker: View {
    @Binding var selection: Int
    @State var size = CGFloat(22)
    @State var color = Color.accentColor
    @State var items: [String]
    
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(items.indices, id: \.self) { i in
                Button(width: size, height: size) {
                    
                } content: {
                    Image(systemName: items[i])
                        .font(.system(size: size*0.8))
                        .debug(.blue)
                }
                .debug()
                .tag(i)

                Spacer()
            }
        }
        .frame(height: size + 15)
    }
}

#if DEBUG
struct TabPicker_Previews: PreviewProvider {
    @State static var selected = 0
    
    static var previews: some View {
        VStack {
            TabPicker(selection: $selected, items: [
                "trash", "trash.fill"
            ])
            .debug()
            .frame(size: CGSize(width: 300, height: 50))
            
            TabPicker(selection: $selected, items: [
                "trash", "trash.fill"
            ])
            .debug()
            .frame(size: CGSize(width: 300, height: 50))
        }
    }
}
#endif
