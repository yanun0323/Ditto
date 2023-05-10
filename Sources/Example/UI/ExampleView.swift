import SwiftUI
import Ditto

struct ExampleView: View {
    @Environment(\.injected) private var container: DIContainer
    var body: some View {
        VStack {
            Text("Hello")
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
            .inject(DIContainer(isMock: true))
    }
}
