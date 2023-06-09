import Foundation
import Combine

/** **\*Deprecated\*** Use *`UserDefaultState`* instead */
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

/** **\*Deprecated\*** Use *`UserDefaultState`* instead */
@available(iOS 16, macOS 13, watchOS 9, *)
extension UserDefault where Value: ExpressibleByNilLiteral {
    
    
    /** **\*Deprecated\*** Use *UserDefaultState* instead */
    public init(key: String, defaultValue: Value = nil, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: defaultValue, container: container)
    }
}
