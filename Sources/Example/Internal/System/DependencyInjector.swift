import SwiftUI
import Ditto
import Sworm

extension DIContainer {
    var appstate: AppState { AppState.get() }
    var interactor: Interactor { Interactor.get(isMock: self.isMock) }
}

struct Interactor {
    private static var `default`: Interactor? = nil
    
    let data: DataInteractor
    let preference: PreferenceInteractor
    
    init(appstate: AppState, isMock: Bool) {
        let repo: Repository = Dao()
        
        SQL.getDriver().migrate([
            Student.self
        ])
        
        self.data = DataInteractor(appstate: appstate, repo: repo)
        self.preference = PreferenceInteractor(appstate: appstate, repo: repo)
    }
}

extension Interactor {
    public static func get(isMock: Bool) -> Self {
        if Self.default.isNil {
            Self.default = Interactor(appstate: AppState.get(), isMock: isMock)
        }
        return Self.default!
    }
}
