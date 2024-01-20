# Ditto

Ditto is a powerful pakage for swiftUI.

- [Dependency Injector](#dependency-injector)
- [UserDefault](#userdefault)
- [System](#system)
- [Http](#http)
- [Hotkey](#hotkey)
- [UI](#ui)
    - [Block](#block)
    - [Section](#section)
    - [Separator](#separator)

## Requirement
_**iOS 17.0** , **macOS 14** or Higher_

## Dependency Injector

Ditto uses `Dependency Injector` to follow [`Clean Architecture`](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).


Inspired by [`clean-architecture-swiftui`](https://github.com/nalexn/clean-architecture-swiftui)

### Clean Architecture Structure
```
Project
|
|-- UI
|
|-- Internal
    |
    |-- System
    |-- Domain
    |-- Interactor
    |-- Model
    |-- Repo
        ...
```
- **UI**
    - App views cross different platform
- **System**
    - `DIContainer` ***Dependency Injector*** instance. contain `AppState` and `Interactor`
    - `AppState` ***Stateful***, stores value and data publisher, it store `state` of App.
- **Interactor**
    - ***Stateless***, contain all of the business logic and `Repository`, `AppState` instances.
    - Access data through `Repo`.
- **Model**
    - Define the structures of data
- **Domain**
    - Define `Protocol` which interact with the database or other sources.
    - It separates Application layer and Repository Layer
- **Repository**
    - Implement the `Protocol` from `Domain`
    - Easily change functions here to get the data from different source.
- **Other**
    - `Util`
    - `Extension`
    - Others...

Check [`Example Folder`][example] for more information.

[example]: https://github.com/yanun0323/Ditto/tree/master/Sources/Example

Check [`Repo Folder`][sql] for more information, and more use cases [`DataDao.swift`][dataDao]

[sql]: https://github.com/yanun0323/Ditto/tree/master/Sources/Example/Internal/Repo
[dataDao]: https://github.com/yanun0323/Ditto/blob/master/Sources/Example/Internal/Repo/DataDao.swift

### DIContainer
`DIContainer` is the instance of `Dependency Injector`.

Inspired by [`clean-architecture-swiftui`](https://github.com/nalexn/clean-architecture-swiftui)

#### Sample Code


`System.swift`
```swift
// Define AppState & Interactor in DIContainer
 struct DIContainer: DependencyInjector {
     static var defaultValue: DIContainer { DIContainer(mock: true) }
     
     var appstate: AppState
     var interactor: Interactor
     
     init(mock inMemory: Bool) {
         let appstate = AppState()
         self.appstate = appstate
         self.interactor = Interactor(appstate, repo: Dao(mock: inMemory))
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

// Define Interactor
struct Interactor {
    init(_ appstate: AppState, repo: Repository)
}

// Define AppState
struct AppState {
    init()
}

```

`MyApp.swift`
```swift
// Inject DIContainer into App
@main
struct MyApp: App {
    private var container = DIContainer()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .inject(container)
        }
    }
}
```

`ContentView.swift`
```swift
// Get DIContainer from environment
struct ContentView: View {
    @Environment(\.container) private var container: DIContainer

    var body: some View {
        // ...
    }
}

// Inject DIContainer into Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
                .inject(.preview)
    }
}
```

## UserDefaultState
Property Wrapper for `UserDefaults`.

#### Sample Code
```swift
 // define
 extension UserDefaults {
    @UserDefaultState(key: "USERNAME", defaultValue: "yanun", container: .standard)
    static var username: String

    @UserDefaultState(key: "username")
    static var username: String?
 }
    
 // usage
 let subscription = UserDefaults.$username.sink { username in
    print("New username: \(username)")
 }
     
 UserDefaults.username = "Test"
 // prints: New username: Test
```

## System
Useful function for system.
- _static variable_
    - **version** : app version
    ```swift
        let version = System.version
    ```
    - **build** : app bundle version
    ```swift
        let build = System.build
    ```
    - **screen** : **_`iOS only`_** get device screen bounds.
    ```swift
        let screen = System.screen
        screen.height   /* device height */
        screen.width    /* device width *
    ```
- _static function_

    - **async** : invoke function in background thread and main thread. 
    ```swift
        func foo() {
            
        }

        System.async {
            foo()
        } main: {
            /* Change View */
        }
    ```

    - **asyncio** : invoke function in background thread and passing data to main thread. 
    ```swift
        func foo() -> bool {
            return true
        }

        System.asyncio {
            return foo()
        } main: { data in
            /* Change View */
        }
    ```

    - **try** : invoke function which contains `throws` safely. print log gracefully when error occurs.
    ```swift
        func foo() throws {

        }

        System.try("foo") {
            try foo()
        }
    ```

    - **tryio** : invoke function which contains `throws` with return value safely. print log gracefully when error occurs.
    ```swift
        func foo() throws -> Bool {
            return true
        }

        System.tryio("foo") {
            return try foo()
        } ?? false
    ```

    - **unfocus** : **_`macOS only`_** unfocus all input field.
    ```swift
        System.unfocus()
    ```

## Http
Wrapper for Http request.

### Sample Code
```swift
let url = "http://api/user"
    let (user, code, error) = Http.SendRequest(.GET, toUrl: url, type: User.self) { req in
    req.setHeader("Token", "foo")
    // do something ...
}
```

## Hotkey
*\*macOS only\** A SwiftUI view extension make you invoke action with custom hotkeys.

### Sample Code
```swift
VStack {
    // views...
}
.hotkey(key: .kVK_ANSI_A, keyBase: [KeyBase.command]) {
    NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: nil)
}
.hotkey(key: .kVK_ANSI_C, keyBase: [KeyBase.command]) {
    NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: nil)
}
.hotkey(key: .kVK_ANSI_X, keyBase: [KeyBase.command]) {
    NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: nil)
}
.hotkey(key: .kVK_ANSI_V, keyBase: [KeyBase.command]) {
    NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: nil)
}
.hotkey(key: .kVK_ANSI_Z, keyBase: [KeyBase.command]) {
    NSApp.sendAction(Selector(("undo:")), to: nil, from: nil)
}
.hotkey(key: .kVK_ANSI_Z, keyBase: [KeyBase.shift, KeyBase.command]) {
    NSApp.sendAction(Selector(("redo:")), to:nil, from:self)
}
```

## UI
Custom Views for SwiftUI.

### [**Block**][block]
Like `SwiftUI.Rectangle`, but you can define ***width***, ***height*** and ***color*** in constructor

```swift
    /* A 10 width, 10 height, blue block */
    Block(width: 10, height: 10, color: .blue) 

    /* A infinity width, 10 height, transparent block */
    Block(height: 10) 

    /* A infinity width, infinity height, transparent block */
    Block() 
```

### [**Section**][section]
Another simple section block

```swift
    Section("Title") {
        Text("Content")
    }

    Section("Title", font: .title3, color: .gray, radius: 10, bg: .gray) {
        Text("Content 1")
        Text("Content 2")
    }
```

### [**Separator**][separator]
Better than `SwiftUI.Divider`
```swift
    Separator(direction: .vertical)

    Separator(direction: .vertical, color: .gray, size: 3)
```

[block]: https://github.com/yanun0323/Ditto/tree/master/Sources/Ditto/UI/Block.swift
[button]: https://github.com/yanun0323/Ditto/tree/master/Sources/Ditto/UI/Button.swift
[section]: https://github.com/yanun0323/Ditto/tree/master/Sources/Ditto/UI/Section.swift
[separator]: https://github.com/yanun0323/Ditto/tree/master/Sources/Ditto/UI/Separator.swift
