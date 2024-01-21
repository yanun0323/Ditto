import SwiftUI

public protocol Defaultable {
    associatedtype MetaType = Self
    var `default`: MetaType { get }
}
