# Ditto

Ditto is a powerful pakage for swiftUI.

- [Dependency Injector](#dependency-injector)
- [UserDefault](#userdefault)
- [System](#system)
- [Http](#http)
- [Hotkey](#hotkey)
- [UI](#ui)
    - [Button](#button)
    - [Block](#block)
    - [Section](#section)
    - [Separator](#separator)

## Requirement
_**iOS 16.0** , **macOS 13** or Higher_

## Dependency Injector

Ditto uses `Dependency Injector` to follow [`Clean Architecture`](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).


Inspired by [`clean-architecture-swiftui`](https://github.com/nalexn/clean-architecture-swiftui)

### Structure
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
    - `DIContainer` ***Dependency Injector*** instance. contain `AppState` and `Interaction`
    - `AppState` ***Stateful***, stores value and data publisher, it store `state` of App.
- **Interactor**
    - ***Stateless***, contain all of the business logic and `Repo`, `AppState` instances.
    - Access data through `Repo`.
- **Model**
    - Define the structures of data
- **Domain**
    - Define `Protocol` which interact with the database or other sources.
    - It separates Application layer and Repository Layer
- **Repo**
    - Implement the `Protocol` from `Domain`
    - Easily change functions here to get the data from different source.
- **Other**
    - `Util`
    - `Extension`
    - Others...

Check [`Example Folder`][example] for more information.

[example]: https://github.com/yanun0323/Ditto/tree/master/Sources/Example

Check [`SQL Folder`][sql] for more information, and more use cases [`DataDao.swift`][dataDao]

[sql]: https://github.com/yanun0323/Ditto/tree/master/Sources/Example/Internal/SQLite
[dataDao]: https://github.com/yanun0323/Ditto/blob/master/Sources/Example/Internal/Repo/DataDao.swift

## UserDefault
Property Wrapper for `UserDefaults`.

#### Sample Code
```swift
extension UserDefaults {
    @UserDefault(key: "username")
    static var username: String?
}
 
let subscription = UserDefaults.$username.sink { username in
    print("New username: \(username)")
}

UserDefaults.username = "Test"
// Prints: New username: Test
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
    - **async** : invoke function in background thread and and transport data to main thread. 
    ```swift
        func foo() -> bool {
            return true
        }

        System.async {
            return foo()
        } main: { data in
            /* Change View */
        }
    ```
    - **doCatch** : invoke function which contains `throws` safely, and print log gracefully when error occurs.
    ```swift
        func foo() throws -> Bool {
            return true
        }

        System.doCatch("foo") {
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
    let user = Http.SendRequest(.GET, toUrl: url, type: User.self) { req in
    var request = req
    // do something ...
    return request
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

### [**Button**][button]
Build from `SwiftUI.Button`, but more powerful

```swift
    /* a transparent button, but it still be pressed when pressing the transparent area */
    Button(width: 100, height: 20) {
        print("Invoke Something Here")     
    } content: {
        Text("Transparent Button")
    }

    /* a gradient button */
    Button(width: 50, height: 50, colors: [.cyan, .green], radius: 30, shadow: 5) {
        print("Invoke Something Here")     
    } content: {
        Image(systemName: "plus")
            .font(.system(size: 25))
            .foregroundColor(.white)
    }
```

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
