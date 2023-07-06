import SwiftUI
import Ditto
import SQLite
import Sworm

extension Student: Migrator {
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    static let age = Expression<Int>("age")
    static let sex = Expression<Student.Sex>("sex")
    
    static var table: Tablex { .init("students") }
    
    static func migrate(_ conn: Connection) throws {
        try conn.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name, unique: true)
            t.column(age)
            t.column(sex)
        })
        try conn.run(table.createIndex(name, ifNotExists: true))
    }
    
    static func parse(_ row: Row) throws -> Student {
        return Student(
            id: try row.get(id),
            name: try row.get(name),
            age: try row.get(age),
            sex: try row.get(sex)
        )
    }
    
    func setter() -> [Setter] {
        return [
            Student.id <- id,
            Student.name <- name,
            Student.age <- age
        ]
    }
}
