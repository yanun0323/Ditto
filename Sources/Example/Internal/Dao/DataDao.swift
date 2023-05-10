import SwiftUI
import SQLite
import Ditto

protocol DataDao {}

extension DataDao where Self: DataRepository {
    func Tx<T>(_ action: () throws -> T?) throws -> T? where T: Any {
        var result: T?
        try SQL.getDriver().transaction {
            result = try action()
        }
        return result
    }
    
    func GetStudent(_ id: Int64) throws -> Student? {
        let query = Student.table.filter(id == Student.id)
        let results = try SQL.getDriver().prepare(query)
        for r in results {
            return try Student.parse(r)
        }
        
        return nil
    }
    
    func CreateStudent(_ s: Student) throws -> Int64 {
        let insert = Student.table.insert(
            Student.id <- s.id,
            Student.name <- s.name,
            Student.age <- s.age
        )
        return try SQL.getDriver().run(insert)
    }
    
    func UpdateStudent(_ id: Int64, _ s: Student) throws {
        let update = Student.table.filter(Student.id == id).update(
            Student.id <- s.id,
            Student.name <- s.name,
            Student.age <- s.age
        )
        try SQL.getDriver().run(update)
    }
    
    func DeleteStudent(_ id: Int64) throws {
        try SQL.getDriver().run(Student.table.filter(Student.id == id).delete())
    }
    
}
