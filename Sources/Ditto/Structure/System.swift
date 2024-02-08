import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct System {
    /** application bundle version */
    public static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    /** application bundle build */
    public static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
}

extension System {
    /**
     # async
     Invoke function in background thread and main thread
     */
    public static func async(background: @escaping () -> Void = {}, main: @escaping () -> Void) {
        DispatchQueue.global().async {
            background()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                main()
            }
        }
    }
    
    /**
     # async
     Invoke function in background thread and main thread with passing data
     */
    public static func asyncio<T>(background: @escaping () -> T = {}, main: @escaping (T) -> Void) {
        DispatchQueue.global().async {
            let data = background()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                main(data)
            }
        }
    }
}

extension System {
    /**
     # try
     handle simple do/catch action
     */
    public static func `try`(_ log: String? = nil, _ action: () throws -> Void){
        do {
            try action()
        } catch {
            if let log = log {
                print("Error: \(log), err: \(error)")
            } else {
                print("Error: \(error)")
            }
        }
    }
    
    /**
     # tryio
     handle simple do/catch action with return data
     */
    public static func tryio<T>(_ log: String? = nil, _ action: () throws -> T?) -> T? where T: Any {
        do {
            return try action()
        } catch {
            if let log = log {
                print("Error: \(log), err: \(error)")
            } else {
                print("Error: \(error)")
            }
        }
        return nil
    }
}

#if os(macOS)
extension System {
    /**
     # unfocus
     unfocus current focus window
     */
    public static func unfocus() {
        NSApp.keyWindow?.makeFirstResponder(nil)
    }
    
    /**
     # copy
     Copy text to system clipboard
     */
    public static func copy(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
#elseif os(iOS)
extension System {
    /**
     # dismissKeyboard
     dismiss iOS keyboard
     */
    public static func dismissKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }
}
#endif

#if DEBUG
#Preview {
    SystemPreview()
        .paddings()
}

struct SystemPreview: View {
    @State private var num = 1
    var body: some View {
        VStack {
            Text("\(num)")
            Button {
                num += 1
                System.async {
                    num+=1
                }
            } label: {
                Text("Add")
            }
        }
    }
}
#endif
