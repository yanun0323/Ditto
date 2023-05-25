import SwiftUI

struct Student {
    var id: Int64 = 0
    var name: String
    var age: Int
    var sex: Sex
}

extension Student: Hashable, Identifiable {}

extension Student {
    enum Sex {
        case male, female, others
        
        var string: String {
            switch self {
                case .male:
                    return "male"
                case .female:
                    return "female"
                case .others:
                    return "other"
            }
        }
        
        init(_ string: String) {
            switch string {
                case Self.male.string:
                    self = .male
                case Self.female.string:
                    self = .female
                default:
                    self = .others
            }
        }
    }
}

extension Student.Sex: Hashable, Identifiable, CaseIterable {
    var id: Self { self }
}
