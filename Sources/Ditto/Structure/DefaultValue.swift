import SwiftUI

public protocol Defaultable {
    associatedtype MetaType = Self
    var `default`: MetaType { get }
}


struct TestDefaultValue: Defaultable {
    public var `default`: TestDefaultValue { .init() }
}
