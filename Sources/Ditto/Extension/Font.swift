import SwiftUI


#Preview {
    Ditto.registerFonts()
    return VStack {
        Text("Font Test 測試")
            .font(.custom(FontName.Cubic11R.rawValue, size: 30, relativeTo: .body))
            .paddings(30)
    }
}
