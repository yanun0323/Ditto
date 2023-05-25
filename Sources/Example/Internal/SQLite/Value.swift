import SwiftUI
import SQLite

extension Student.Sex: Value {
    typealias Datatype = String
    
    static var declaredDatatype: String {
        return String.declaredDatatype
    }
    
    static func fromDatatypeValue(_ datatypeValue: String) -> Student.Sex {
        return Student.Sex(datatypeValue)
    }
    
    var datatypeValue: String {
        return self.string
    }
}
