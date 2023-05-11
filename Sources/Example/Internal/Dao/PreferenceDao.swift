import SwiftUI
import Ditto

protocol PreferenceDao {}

extension PreferenceDao where Self: PreferenceRepository {
    
    func getAccentColor() throws -> Color? {
        return UserDefaults.accentColor
    }
    
    func setAccentColor(_ color: Color) throws {
        UserDefaults.accentColor = color
    }
}

extension UserDefaults {
    @UserDefault(key: "AccentColor")
    static var accentColor: Color?
}
