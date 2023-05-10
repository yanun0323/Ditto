import SwiftUI
import SQLite
import Ditto

protocol DataDao {}

extension DataDao where Self: DataRepository {
    func Tx<T>(_ action: () throws -> T?) throws -> T? where T: Any {
        var result: T?
        try SQL.GetDriver().transaction {
            result = try action()
        }
        return result
    }
    
    func GetStudent(_ id: Int64) throws -> Student? {
        let query = Student.Table().filter(id == Student.id)
        let results = tryㄏ SQL.GetDriver().prepare(query)
        for r in results {
            return try Student.parse(r)
        }
        return nil
    }
    
    func CreateStudent(_ s: Student) throws -> Int64 {
        let insert = Student.Table().insert(
            Student.id <- s.id,
            Student.name <- s.name,
            Student.age <- s.age
        )
        return try SQL.GetDriver().run(insert)
    }
    
    func UpdateStudent(_ id: Int64, _ s: Student) throws {
        let update = Student.Table().filter(Student.id == id).update(
            Student.id <- s.id,
            Student.name <- s.name,
            Student.age <- s.age
        )
        try SQL.GetDriver().run(update)
    }
    
    func DeleteStudent(_ id: Int64) throws {
        try SQL.GetDriver().run(Student.Table().filter(Student.id == id).delete())
    }
    
}
