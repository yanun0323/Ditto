import SwiftUI

public struct DIContainer: EnvironmentKey {
    public static var defaultValue: DIContainer { Self.default }
    public static var `default`: DIContainer {
        return DIContainer()
    }
    
    public let isMock: Bool
    public init(isMock: Bool = false) {
        self.isMock = isMock
    }
}

extension View {
    public func inject(_ container: DIContainer) -> some View {
        self.environment(\.injected, container)
    }
}

extension EnvironmentValues {
    public var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

#if DEBUG
extension DIContainer {
    public static var preview: DIContainer {
        return DIContainer(isMock: true)
    }
}
#endif

