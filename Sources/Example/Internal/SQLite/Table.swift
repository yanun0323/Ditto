import SwiftUI
import Ditto
import SQLite

extension Student {
    static func Table() -> SQLite.Table { .init("students") }
    
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    static let age = Expression<Int>("age")
}

extension Student: Migrater {
    static func migrate(_ conn: Connection) throws {
        try conn.run(Table().create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(name, unique: true)
            t.column(age)
        })
        try conn.run(Table().createIndex(name, ifNotExists: true))
    }
    
    static func parse(_ r: Row) throws -> Student? {
        return Student(
            id: try r.get(id),
            name: try r.get(name),
            age: try r.get(age)
        )
    }
}
