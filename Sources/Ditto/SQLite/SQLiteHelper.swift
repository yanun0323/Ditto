import SwiftUI
import SQLite

/*
 Define Decimal value to make it storable in sqlite
 **/
@available(iOS 15, macOS 12.0, *)
extension Decimal: Value {
    public typealias Datatype = String
    
    public static var declaredDatatype: String {
        return String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ datatypeValue: String) -> Decimal {
        if let d = Decimal(string: datatypeValue) {
            return d
        }
        print("[ERROR] transform string '\(datatypeValue)' to decimal failed")
        return 0
    }
    
    public var datatypeValue: String {
        return self.description
    }
}

/*
 Define Decimal value to make it storable in sqlite
 **/
@available(iOS 15, macOS 12.0, *)
extension Color: Value {
    public typealias Datatype = Blob
    
    public static var declaredDatatype: String {
        return Data.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ datatypeValue: Blob) -> Color {
        do {
            return try JSONDecoder().decode(Color.self, from: Data(datatypeValue.bytes))
        } catch {
            print("decode json to color, err: \(error)")
            return .blue
        }
    }
    
    public var datatypeValue: Blob {
        do {
            return try JSONEncoder().encode(self).datatypeValue
        } catch {
            print("encode color to json, err: \(error)")
            return Blob(bytes: [])
        }
    }
}
