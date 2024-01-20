import Foundation
import Combine

/**
 Property Wrapper for UserDefaults
 
 ```swift
 // define
 extension UserDefaults {
    @UserDefaultState(key: "USERNAME", defaultValue: "yanun", container: .standard)
    static var username: String

    @UserDefaultState(key: "username")
    static var username: String?
 }
    
 // usage
 let subscription = UserDefaults.$username.sink { username in
    print("New username: \(username)")
 }
     
 UserDefaults.username = "Test"
 // Prints: New username: Test
 ```
 */
@propertyWrapper
public struct UserDefaultState<Value> {
    public let key: String
    public let defaultValue: Value
    public var container: UserDefaults = .standard
    private let publisher = PassthroughSubject<Value, Never>()
    
    public var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
            publisher.send(newValue)
        }
    }
    
    public var projectedValue: AnyPublisher<Value, Never> {
        return publisher.eraseToAnyPublisher()
    }
}

extension UserDefaultState {
    public init(key: String, defaultValue: Value = nil, _ container: UserDefaults = .standard) where Value: ExpressibleByNilLiteral {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
    
    public init(key: String, defaultValue: Value, _ container: UserDefaults = .standard) where Value: ExpressibleByStringLiteral {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
    
    public init(key: String, defaultValue: Value, _ container: UserDefaults = .standard) where Value: ExpressibleByBooleanLiteral {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
    
    public init(key: String, defaultValue: Value, _ container: UserDefaults = .standard) where Value: ExpressibleByIntegerLiteral {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
    
    public init(key: String, defaultValue: Value, _ container: UserDefaults = .standard) where Value: ExpressibleByFloatLiteral {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
}


/// Allows to match for optionals with generics that are defined as non-optional.
public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

extension UserDefaults {
    @UserDefaultState(key: "USERNAME", defaultValue: "yanun", container: .standard)
    static var username: String
}
