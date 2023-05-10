import SwiftUI

protocol Repository: DataRepository, PreferenceRepository {}

protocol DataRepository {
    func Tx<T>(_ action: () throws -> T?) throws -> T? where T: Any
    
    func GetStudent(_:Int64) throws -> Student?
    func CreateStudent(_:Student) throws -> Int64
    func UpdateStudent(_:Int64, _:Student) throws
    func DeleteStudent(_:Int64) throws
}

protocol PreferenceRepository {
    func GetAccentColor() -> Color
    func SetAccentColor(_:Color) throws
}
