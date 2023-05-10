import SwiftUI
import Ditto

protocol PreferenceDao {}

extension PreferenceDao where Self: PreferenceRepository {
    
    func GetAccentColor() -> Color {
        return UserDefaults.accentColor ?? .accentColor
    }
    
    func SetAccentColor(_ color: Color) throws {
        UserDefaults.accentColor = color
    }
}

extension UserDefaults {
    @UserDefault(key: "AccentColor")
    static var accentColor: Color?
}
