import Foundation
import SwiftUI
import Combine

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
    public static func async(delay: TimeInterval = 0, background: @escaping () -> Void = {}, main: @escaping () -> Void) {
        DispatchQueue.global()
            .async {
                background()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 + delay) {
                    main()
                }
            }
    }

    /**
     # async
     Invoke function in background thread and main thread with passing data
     */
    public static func asyncio<T>(delay: TimeInterval = 0, background: @escaping () -> T = {}, main: @escaping (T) -> Void) {
        DispatchQueue.global()
            .async {
                let data = background()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 + delay) {
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
    public static func `try`(_ log: String? = nil, _ action: () throws -> Void) {
        do {
            try action()
        } catch {
            if let log = log {
                print("Error: \(log), err: \(error)")
            }
            else {
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
            }
            else {
                print("Error: \(error)")
            }
            return nil
        }
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
     copies text to system clipboard
     */
        public static func copy(_ text: String) {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(text, forType: .string)
        }
        
        /**
        # shell
        executes shell command
        */
        public static func shell(_ cmd: String, receive valueHandler: ((String) -> Void)? = nil) -> String? {
            return shell(cmd, completion: nil, receive: valueHandler)
        }
        
        /**
        # shell
        executes shell command
        */
        public static func shell(_ cmd: String, completion errHandler: ((Subscribers.Completion<Error>) -> Void)?, receive valueHandler: ((String) -> Void)?) -> String? {
            if errHandler != nil && valueHandler != nil {
                System.async {
                    shellAsync(cmd, completion: errHandler, receive: valueHandler)
                }
                return nil
            }
            
            return shellAwait(cmd)
        }
        
        private static func shellAwait(_ cmd: String) -> String? {
            let process = Process()
            let pipe = Pipe()
            
            process.launchPath = "/usr/bin/env"
            process.arguments = cmd.components(separatedBy: CharacterSet.whitespaces)
            process.standardOutput = pipe
            
            do {
                try process.run()
                process.waitUntilExit()
                guard let data = try pipe.fileHandleForReading.readToEnd() else {
                    return "error: data read to end"
                }
                
                
                guard let msg = String(data: data, encoding: String.Encoding.utf8),
                      msg.trimmingCharacters(in: ["\n"," "]).count != 0  else {
                    return "error: parse data to message"
                }
                
                return msg
            } catch {
                return "error: \(error)"
            }
        }
        
        private static func shellAsync(_ cmd: String, completion errHandler: ((Subscribers.Completion<Error>) -> Void)?, receive valueHandler: ((String) -> Void)?) {
            let channel = PassthroughSubject<String, Error>()
            let process = Process()
            let pipe = Pipe()
            
            pipe.fileHandleForReading.readabilityHandler = { p in
                if let msg = String(data: p.availableData, encoding: String.Encoding.utf8),
                      msg.trimmingCharacters(in: ["\n"," "]).count != 0  {
                    channel.asyncSend(msg)
                }
            }
            pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            process.terminationHandler = { _ in
                channel.asyncSend(completion: .finished)
            }
            
            process.launchPath = "/usr/bin/env"
            process.arguments = cmd.components(separatedBy: CharacterSet.whitespaces)
            process.standardOutput = pipe
            
            var subscribtion: AnyCancellable?
            subscribtion = channel.sink { error in
                errHandler?(error)
                subscribtion?.cancel()
                subscribtion = nil
            } receiveValue: { msg in
                valueHandler?(msg)
            }
            
            do {
                try process.run()
                process.waitUntilExit()
            } catch {
                channel.asyncSend("\(error)")
            }
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
    }

    struct SystemPreview: View {
        @State private var publisher = PassthroughSubject<String, Never>()
        @State private var sub: AnyCancellable?
        @State private var num = 1
        @State private var info = "-"
        var body: some View {
            VStack {
                Text("\(num)")
                Button {
                    num += 1
                    System.async {
                        num += 1
                    }
                } label: {
                    Text("Add")
                }
                
                Button {
                    let result = System.shell("/usr/local/bin/ollama list") ?? "-"
                    publisher.asyncSend(result)
                } label: {
                    Text("list")
                }
                
                Button {
                    let result = System.shell("/usr/local/bin/ollama rm stable-code:code") ?? "-"
                    publisher.asyncSend(result)
                } label: {
                    Text("remove")
                }
                
                Button {
                    var result = ""
                    let output = System.shell("/usr/local/bin/ollama pull stable-code:code") { err in
                        publisher.asyncSend(result)
                    } receive: { msg in
                        result.append(result)
                    }
                    publisher.asyncSend(output ?? "...")
                } label: {
                    Text("pull")
                }
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(info.components(separatedBy: "\n"), id: \.self) { text in
                            Text(text)
                        }
                    }
                }
            }
            .frame(width: 500)
            .onReceive(publisher) { msg in
                info = msg
            }
        }
    }
#endif
