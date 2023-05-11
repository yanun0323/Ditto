import SwiftUI

struct Student {
    var id: Int64 = 0
    var name: String
    var age: Int
}

extension Student: Hashable, Identifiable {}
