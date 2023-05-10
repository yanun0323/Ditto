import SwiftUI
import Ditto
import SQLite

extension Student {
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    static let age = Expression<Int>("age")
}

extension Student: Migrater {
    static var table: Tablex { .init("students") }
    
    static func migrate(_ conn: Connection) throws {
        try conn.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name, unique: true)
            t.column(age)
        })
        try conn.run(table.createIndex(name, ifNotExists: true))
    }
    
    static func parse(_ r: Row) throws -> Student? {
        return Student(
            id: try r.get(id),
            name: try r.get(name),
            age: try r.get(age)
        )
    }
}
