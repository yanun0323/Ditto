import SwiftUI
import Ditto

struct PreferenceInteractor {
    let appstate: AppState
    let repo: Repository
}

extension PreferenceInteractor {
    func pushAccentColor() {
        System.async {
            System.doCatch("push get accent color") {
                return try repo.getAccentColor()
            } ?? .accentColor
        } main: { color in
            appstate.pubAccenctColor.send(color)
        }

    }
    
    func getAccentColor() throws -> Color {
        System.doCatch("get accent color") {
            return try repo.getAccentColor()
        } ?? .accentColor
    }
    
    func setAccentColor(_ c: Color) {
        System.doCatch("set accent color") {
            try repo.setAccentColor(c)
        }
    }
}
