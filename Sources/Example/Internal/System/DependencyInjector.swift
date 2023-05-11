import SwiftUI
import Ditto

extension DIContainer {
    var appstate: AppState { AppState.Get() }
    var interactor: Interactor { Interactor.Get(isMock: self.isMock) }
}

struct Interactor {
    private static var `default`: Interactor? = nil
    
    let data: DataInteractor
    let preference: PreferenceInteractor
    
    init(appstate: AppState, isMock: Bool) {
        let repo: Repository = Dao()
        self.data = DataInteractor(appstate: appstate, repo: repo)
        self.preference = PreferenceInteractor(appstate: appstate, repo: repo)
    }
}

extension Interactor {
    public static func Get(isMock: Bool) -> Self {
        if Self.default.isNil {
            Self.default = Interactor(appstate: AppState.Get(), isMock: isMock)
        }
        return Self.default!
    }
}
