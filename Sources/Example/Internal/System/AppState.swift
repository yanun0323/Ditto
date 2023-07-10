import SwiftUI
import Combine

struct AppState {
    private static var `default`: AppState? = nil
    
    public let pubAccenctColor: PassthroughSubject<Color, Never> = .init()
    public let pubStudent: PassthroughSubject<[Student], Never> = .init()
}

extension AppState {
    public static func get() -> Self {
        if Self.default == nil {
            Self.default = Self()
        }
        return Self.default!
    }
}
