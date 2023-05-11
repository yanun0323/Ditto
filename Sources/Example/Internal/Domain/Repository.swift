import SwiftUI

protocol Repository: DataRepository, PreferenceRepository {}

protocol DataRepository {
    func tx<T>(_ action: () throws -> T?) throws -> T? where T: Any
    
    func listStudent() throws -> [Student]
    func getStudent(_:Int64) throws -> Student?
    func createStudent(_:Student) throws -> Int64
    func updateStudent(_:Int64, _:Student) throws
    func deleteStudent(_:Int64) throws
}

protocol PreferenceRepository {
    func getAccentColor() throws -> Color?
    func setAccentColor(_:Color) throws
}
