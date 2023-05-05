import SwiftUI

@available(iOS 15, macOS 12.0, *)
public struct DIContainer: EnvironmentKey {
    public static var defaultValue: DIContainer { Self.default }
    public static var `default`: DIContainer {
        return DIContainer(isMock: true)
    }
    
    public let isMock: Bool
    public init(isMock: Bool = false) {
        self.isMock = isMock
    }
}

@available(iOS 15, macOS 12.0, *)
extension View {
    public func inject(_ container: DIContainer) -> some View {
        self.environment(\.injected, container)
    }
}

@available(iOS 15, macOS 12.0, *)
extension EnvironmentValues {
    public var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}


