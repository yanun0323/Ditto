import SwiftUI

/** Dependency Injector defines the clean architecture manager instance
 ```swift
 struct DIContainer: DependencyInjector {
     static var defaultValue: DIContainer { DIContainer(mock: true) }
     
     var appstate: AppState
     var interactor: Interactor
     
     init(with provider: InjectionProvider) {
         let appstate = AppState()
         self.appstate = appstate
         self.interactor = Interactor(appstate, Dao(mock: inMemory))
     }
 }

 extension View {
     func inject(_ container: DIContainer) -> some View {
         self.environment(\.container, container)
     }
 }

 extension EnvironmentValues {
     var container: DIContainer {
         get { self[DIContainer.self] }
         set { self[DIContainer.self] = newValue }
     }
 }

 #if DEBUG
 extension DIContainer {
     static var preview: DIContainer {
         return DIContainer(mock: true)
     }
 }
 #endif
 ```
 */
public protocol DependencyInjector: EnvironmentKey {
    associatedtype AppStateType
    associatedtype InteractorType
    
    var appstate: AppStateType { get }
    var interactor: InteractorType { get }
}

