import Foundation
import Combine

/**
 Property Wrapper for UserDefaults
 
 ```
 extension UserDefaults {
 @UserDefault(key: "username")
 static var username: String?
 }
 
 let subscription = UserDefaults.$username.sink { username in
 print("New username: \(username)")
 }
 UserDefaults.username = "Test"
 // Prints: New username: Test
 ```
 */
@available(iOS 16, macOS 13, watchOS 9, *)
@propertyWrapper
public struct UserDefault<Value> {
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

@available(iOS 16, macOS 13, watchOS 9, *)
extension UserDefault where Value: ExpressibleByNilLiteral {
    
    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    public init(key: String, defaultValue: Value = nil, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
}


/// Allows to match for optionals with generics that are defined as non-optional.
@available(iOS 16, macOS 13, watchOS 9, *)
public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}
@available(iOS 16, macOS 13, watchOS 9, *)
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
