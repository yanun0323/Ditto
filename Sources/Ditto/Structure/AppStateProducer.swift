import Combine
import SwiftUI

/**
 - Example:
 ```swift
 struct AppState: AppStateProducer {
     var current = CurrentValueSubject<Int, Never>(1)
     var passthrough = PassthroughSubject<Int?, Never>()
 }

 extension KeyPath {
     static var current: KeyPath<AppState, CurrentValueSubject<Int, Never>> {
         return \AppState.current
     }
     
     static var passthrough: KeyPath<AppState, PassthroughSubject<Int?, Never>> {
         return \AppState.passthrough
     }
 }
 ```
 */
public protocol AppStateProducer {}

public extension AppStateProducer {
    func consume<Value: Publisher>(keyPath: KeyPath<Self, Value>, _ perform: @escaping (Value.Output) -> Void) -> AnyCancellable {
        self[keyPath: keyPath].sink { _ in } receiveValue: { output in
            perform(output)
        }
    }
    
    func consume<Value: Publisher>(writable keyPath: WritableKeyPath<Self, Value>, _ perform: @escaping (Value.Output) -> Void) -> AnyCancellable {
        self[keyPath: keyPath].sink { _ in } receiveValue: { output in
            perform(output)
        }
    }
    
    func consume<Value: Publisher>(reference keyPath: ReferenceWritableKeyPath<Self, Value>, _ perform: @escaping (Value.Output) -> Void) -> AnyCancellable {
        self[keyPath: keyPath].sink { _ in } receiveValue: { output in
            perform(output)
        }
    }
}

#if DEBUG
struct AppState: AppStateProducer {
    var current = CurrentValueSubject<Int, Never>(1)
    var passthrough = PassthroughSubject<Int?, Never>()
}

extension KeyPath {
    static var current: WritableKeyPath<AppState, CurrentValueSubject<Int, Never>> {
        return \AppState.current
    }
    
    static var passthrough: WritableKeyPath<AppState, PassthroughSubject<Int?, Never>> {
        return \AppState.passthrough
    }
}

struct DIContainer<State> where State: AppStateProducer {
    let appstate: State
    let interactor: AppState
}

struct AppStateView: View {
    @State var container: DIContainer<AppState>
    @State private var cancellable: [AnyCancellable] = []
    @State private var value: Int = 0
    @State private var channel: Int? = nil
    @State private var state: Int = 0
    
    var body: some View {
        VStack {
            Text("value: \(value)")
            Text("channel: \(channel ?? -1)")
            Text("state: \(state)")
            Button {
                System.async {
                    container.interactor.current.send(value+1)
                    container.interactor.passthrough.send((channel ?? 0) + 1)
                }
                state += 1
            } label: {
                Text("Add")
            }
        }
        .onAppear {
            cancellable.append(container.appstate.consume(keyPath: .current) { value = $0 } )
            cancellable.append(container.appstate.consume(keyPath: .passthrough) { channel = $0 } )
        }
    }
}

#Preview {
    let appstate = AppState()
    return AppStateView(container: DIContainer(appstate: appstate, interactor: appstate)).frame(100).paddings()
}
#endif

