import SQLite
import SwiftUI

// MARK: SQLite Instance
/**
 Property Wrapper for SQLite instance
 
 ```
 // initial the SQL before use it
 let db = SQL.Init(dbName: "database", isMock: false) /* use in memory sqlite database if isMock is true*/
 // get db
 let db = SQL.GetDriver()
 ```
 */
@available(iOS 15, macOS 12.0, *)
public struct SQL {
    private static var db: Connection? = nil
}

@available(iOS 15, macOS 12.0, *)
extension SQL {
    /** Get sqlite database instance. if no exist, create a in memory sqlite database  connection */
    public static func GetDriver() -> Connection {
        if let conn = db {
            return conn
        }
        return self.Init(isMock: true)
    }
    /** Create a new sqlite database instance, use in memory sqlite database if isMock is true */
    public static func Init(dbName name: String? = nil, isMock: Bool) -> Connection {
        var dbName = "production"
        if let name = name, !name.isEmpty {
            dbName = name
        }
        let conn: Connection
        if isMock {
            conn = try! Connection(filePath(dbName).absoluteString)
        } else {
            conn = try! Connection(.inMemory)
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

// MARK: Migrater
@available(iOS 15, macOS 12.0, *)
public protocol Migrater {
    /** Migrate sqlite datebase schema */
    static func migrate(_:Connection) throws
    /** Parse object from result row */
    static func parse(_:Row) throws -> Self?
}

// MARK: Connection
@available(iOS 15, macOS 12.0, *)
extension Connection {
    /** Run table migrations */
    public func Migrate(_ migraters: [Migrater.Type]) {
        System.DoCatch("migrate tables") {
            for m in migraters {
                try m.migrate(self)
            }
        }
    }
}
