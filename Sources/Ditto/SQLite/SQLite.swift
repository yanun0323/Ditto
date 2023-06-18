import SQLite
import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
public typealias Tablex = SQLite.Table

// MARK: SQLite Instance
/**
 Property Wrapper for SQLite instance
 
 ```
 // initial the SQL before use it
 let db = SQL.setup(dbName: "database", isMock: false) /* use in memory sqlite database if isMock is true*/
 // get db
 let db = SQL.getDriver()
 ```
 */
@available(iOS 16, macOS 13, watchOS 9, *)
public struct SQL {
    private static var db: Connection? = nil
}

@available(iOS 16, macOS 13, watchOS 9, *)
extension SQL {
    /** Get sqlite database instance. if no exist, create a in memory sqlite database  connection */
    public static func getDriver() -> Connection {
        if let conn = db {
            return conn
        }
        return self.setup(isMock: true)
    }
    /** Create a new sqlite database instance, use in memory sqlite database if isMock is true */
    public static func setup(dbName name: String? = nil, isMock: Bool) -> Connection {
        var dbName = "production"
        if let name = name, !name.isEmpty {
            dbName = name
        }
        let conn: Connection
        if isMock && (name == nil || name!.isEmpty) {
            conn = try! Connection(.inMemory)
        } else {
            conn = try! Connection(filePath(dbName).absoluteString)
        }
        conn.busyTimeout = 5

        db = conn
        return db!
    }

    private static func filePath(_ filename: String) -> URL {
        return try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(filename).sqlite")
    }
}

// MARK: Migrator
/**
 define for migrate table in sqlite
 ```
 // Sample
 extension Element: Migrator {
     static let id = Expression<Int64>("id")
     static let name = Expression<String>("name")
     static let value = Expression<Blob>("value")
     
     static var table: Tablex { .init("elements") }
     
     static func migrate(_ conn: Connection) throws {
         try conn.run(table.create(ifNotExists: true) { t in
             t.column(id, primaryKey: .autoincrement)
             t.column(name, unique: true)
             t.column(value)
         })
         
         try conn.run(table.createIndex(name, ifNotExists: true))
     }
     
     static func parse(_ r: Row) throws -> Element {
         return Element(
             id: try r.get(id),
             name: try r.get(name),
             value: try r.get(value)
         )
     }
 }
 
 ```
 */
@available(iOS 16, macOS 13, watchOS 9, *)
public protocol Migrator {
    static var table: Tablex { get }
    /**
     Migrate sqlite datebase schema
     ```
     // Sample
     static func migrate(_ conn: Connection) throws {
         try conn.run(table.create(ifNotExists: true) { t in
         t.column(id, primaryKey: .autoincrement)
         t.column(name, unique: true)
         t.column(value)
         })
         try conn.run(table.createIndex(name, ifNotExists: true))
     }
     ```
     
     */
    static func migrate(_:Connection) throws
    /**
     Parse object from result row
     ```
     // Sample
     static func parse(_ r: Row) throws -> Element {
         return Element(
             id: try r.get(id),
             name: try r.get(name),
             value: try r.get(value)
         )
     }
     ```
     */
    static func parse(_:Row) throws -> Self
    
    func setter() -> [Setter]
}

// MARK: Connection
@available(iOS 16, macOS 13, watchOS 9, *)
extension Connection {
    /** Run table migrations */
    public func migrate(_ migrators: [Migrator.Type]) {
        System.doCatch("migrate tables") {
            for m in migrators {
                try m.migrate(self)
            }
        }
    }
    
    public func query<V: Value>(_ query: ScalarQuery<V>) throws -> V {
        return try self.scalar(query)
    }
    
    public func query(_ query: QueryType) throws -> AnySequence<Row>{
        return try self.prepare(query)
    }
    
    public func listSchema(_ tableName: String) throws {
        let columns = try self.schema.columnDefinitions(table: tableName)
        print("'\(tableName)' schema:")
        for column in columns {
            print("'\(column.name)', type: \(column.type.rawValue), pk:\(!column.primaryKey.isNil), nullable: \(column.nullable)")
        }
    }
    
    public func insert(_ m: Migrator) throws -> Int64 {
        return try self.run(T(m).table.insert(m.setter()))
    }
    
    public func upsert(_ m: Migrator, primaryKey pk: Expressible, `where`: Expression<Bool>) throws -> Int64 {
        return try SQL.getDriver().run(T(m).table.where(`where`).upsert(m.setter(), onConflictOf: pk, set: m.setter()))
    }
    
    public func update(_ m: Migrator, `where`: Expression<Bool>) throws -> Int {
        return try SQL.getDriver().run(T(m).table.where(`where`).update(m.setter()))
    }
    
    private func T(_ m: Migrator) -> Migrator.Type {
        return type(of: m)
    }
}
