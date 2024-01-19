import SwiftUI

public enum Errors: Error {
    case msg(String)
    case wrap(String, Error)
}

extension Errors: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .msg(message):
            return "Error: \(message)"
        case let .wrap(message, error):
            return "Error: \(message)\n:: \(error)"
        }
    }
}

extension Errors: CustomLocalizedStringResourceConvertible {
    public var localizedStringResource: LocalizedStringResource {
        return LocalizedStringResource(stringLiteral: description)
    }
}

extension Errors: _FormatSpecifiable {
    public var _arg: String {
        return self.description
    }
    
    public typealias _Arg = String
    
    public var _specifier: String {
        return self.description
    }
    
    public static func == (lhs: Errors, rhs: Errors) -> Bool {
        return lhs.description == rhs.description
    }
}

#if DEBUG
#Preview {
    let error = Errors.wrap("message here", Errors.wrap("this is wrapped error", Errors.msg("this is another error")))
    return VStack {
        Text("\(error)")
            .frame(width: 500)
            .lineLimit(1)
            .onAppear {
                print(error)
            }
    }
}
#endif
