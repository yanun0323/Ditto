#if os(macOS)
import Foundation
import SwiftUI
import Combine
import CoreGraphics

@available(macOS 13, *)
extension View {
    public func hotkey(key: CGKeyCode, keyBase: [KeyBase], action: @escaping () -> Void) -> some View {
        self.modifier(HotKeysMod([Hotkey(keyBase: keyBase, key: key, action: action)]))
    }
    public func hotkeys( _ hotkeys: [Hotkey] ) -> some View {
        self.modifier(HotKeysMod(hotkeys))
    }
}   

@available(macOS 13, *)
public struct HotKeysMod: ViewModifier {
    @State public var subs = Set<AnyCancellable>() // Cancel onDisappear
    public var hotkeys: [Hotkey]
    
    public init(_ hotkeys: [Hotkey] ) {
        self.hotkeys = hotkeys
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            DisableSoundsView(hotkeys:hotkeys)
            content
        }
    }
}

@available(macOS 13, *)
public struct DisableSoundsView: NSViewRepresentable {
    public var hotkeys: [Hotkey]
    
    public func makeNSView(context: Context) -> NSView {
        let view = DisableSoundsNSView()
        
        view.hotkeys = hotkeys
        
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) { }
}

@available(macOS 13, *)
public class DisableSoundsNSView: NSView {
    public var hotkeys: [Hotkey] = []
    
    public override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return hotkeysSubscription(combinations: hotkeys)
    }
}

@available(macOS 13, *)
fileprivate func hotkeysSubscription(combinations: [Hotkey]) -> Bool {
    for comb in combinations {
        let basePressedCorrectly = comb.keyBasePressed
        
        if basePressedCorrectly && comb.key.isPressed {
            comb.action()
            return true
        }
    }
    
    return false
}

///////////////////////
///HELPERS
///////////////////////
@available(macOS 13, *)
public struct Hotkey {
    let keyBase: [KeyBase]
    let key: CGKeyCode
    let action: () -> ()
    
    public init(keyBase: [KeyBase], key: CGKeyCode, action: @escaping () -> Void) {
        self.keyBase = keyBase
        self.key = key
        self.action = action
    }
}

@available(iOS 16, macOS 13, watchOS 9, *)
extension Hotkey {
    public var keyBasePressed: Bool {
        let mustBePressed    = KeyBase.allCases.filter{ keyBase.contains($0) }
        let mustBeNotPressed = KeyBase.allCases.filter{ !keyBase.contains($0) }
        
        for base in mustBePressed {
            if !base.isPressed {
                return false
            }
        }
        
        for base in mustBeNotPressed {
            if base.isPressed {
                return false
            }
        }
        
        return true
    }
}

@available(iOS 16, macOS 13, watchOS 9, *)
public enum KeyBase: CaseIterable {
    case option
    case command
    case shift
    case control
    
    public var isPressed: Bool {
        switch self {
            case .option:
                return CGKeyCode.kVK_Option.isPressed  || CGKeyCode.kVK_RightOption.isPressed
            case .command:
                return CGKeyCode.kVK_Command.isPressed || CGKeyCode.kVK_RightCommand.isPressed
            case .shift:
                return CGKeyCode.kVK_Shift.isPressed   || CGKeyCode.kVK_RightShift.isPressed
            case .control:
                return CGKeyCode.kVK_Control.isPressed || CGKeyCode.kVK_RightControl.isPressed
        }
    }
}

///https://gist.github.com/chipjarred/cbb324c797aec865918a8045c4b51d14
extension CGKeyCode {
    public static let kVK_ANSI_A                    : CGKeyCode = 0x00
    public static let kVK_ANSI_S                    : CGKeyCode = 0x01
    public static let kVK_ANSI_D                    : CGKeyCode = 0x02
    public static let kVK_ANSI_F                    : CGKeyCode = 0x03
    public static let kVK_ANSI_H                    : CGKeyCode = 0x04
    public static let kVK_ANSI_G                    : CGKeyCode = 0x05
    public static let kVK_ANSI_Z                    : CGKeyCode = 0x06
    public static let kVK_ANSI_X                    : CGKeyCode = 0x07
    public static let kVK_ANSI_C                    : CGKeyCode = 0x08
    public static let kVK_ANSI_V                    : CGKeyCode = 0x09
    public static let kVK_ANSI_B                    : CGKeyCode = 0x0B
    public static let kVK_ANSI_Q                    : CGKeyCode = 0x0C
    public static let kVK_ANSI_W                    : CGKeyCode = 0x0D
    public static let kVK_ANSI_E                    : CGKeyCode = 0x0E
    public static let kVK_ANSI_R                    : CGKeyCode = 0x0F
    public static let kVK_ANSI_Y                    : CGKeyCode = 0x10
    public static let kVK_ANSI_T                    : CGKeyCode = 0x11
    public static let kVK_ANSI_1                    : CGKeyCode = 0x12
    public static let kVK_ANSI_2                    : CGKeyCode = 0x13
    public static let kVK_ANSI_3                    : CGKeyCode = 0x14
    public static let kVK_ANSI_4                    : CGKeyCode = 0x15
    public static let kVK_ANSI_6                    : CGKeyCode = 0x16
    public static let kVK_ANSI_5                    : CGKeyCode = 0x17
    public static let kVK_ANSI_Equal                : CGKeyCode = 0x18
    public static let kVK_ANSI_9                    : CGKeyCode = 0x19
    public static let kVK_ANSI_7                    : CGKeyCode = 0x1A
    public static let kVK_ANSI_Minus                : CGKeyCode = 0x1B
    public static let kVK_ANSI_8                    : CGKeyCode = 0x1C
    public static let kVK_ANSI_0                    : CGKeyCode = 0x1D
    public static let kVK_ANSI_RightBracket         : CGKeyCode = 0x1E
    public static let kVK_ANSI_O                    : CGKeyCode = 0x1F
    public static let kVK_ANSI_U                    : CGKeyCode = 0x20
    public static let kVK_ANSI_LeftBracket          : CGKeyCode = 0x21
    public static let kVK_ANSI_I                    : CGKeyCode = 0x22
    public static let kVK_ANSI_P                    : CGKeyCode = 0x23
    public static let kVK_ANSI_L                    : CGKeyCode = 0x25
    public static let kVK_ANSI_J                    : CGKeyCode = 0x26
    public static let kVK_ANSI_Quote                : CGKeyCode = 0x27
    public static let kVK_ANSI_K                    : CGKeyCode = 0x28
    public static let kVK_ANSI_Semicolon            : CGKeyCode = 0x29
    public static let kVK_ANSI_Backslash            : CGKeyCode = 0x2A
    public static let kVK_ANSI_Comma                : CGKeyCode = 0x2B
    public static let kVK_ANSI_Slash                : CGKeyCode = 0x2C
    public static let kVK_ANSI_N                    : CGKeyCode = 0x2D
    public static let kVK_ANSI_M                    : CGKeyCode = 0x2E
    public static let kVK_ANSI_Period               : CGKeyCode = 0x2F
    public static let kVK_ANSI_Grave                : CGKeyCode = 0x32
    public static let kVK_ANSI_KeypadDecimal        : CGKeyCode = 0x41
    public static let kVK_ANSI_KeypadMultiply       : CGKeyCode = 0x43
    public static let kVK_ANSI_KeypadPlus           : CGKeyCode = 0x45
    public static let kVK_ANSI_KeypadClear          : CGKeyCode = 0x47
    public static let kVK_ANSI_KeypadDivide         : CGKeyCode = 0x4B
    public static let kVK_ANSI_KeypadEnter          : CGKeyCode = 0x4C
    public static let kVK_ANSI_KeypadMinus          : CGKeyCode = 0x4E
    public static let kVK_ANSI_KeypadEquals         : CGKeyCode = 0x51
    public static let kVK_ANSI_Keypad0              : CGKeyCode = 0x52
    public static let kVK_ANSI_Keypad1              : CGKeyCode = 0x53
    public static let kVK_ANSI_Keypad2              : CGKeyCode = 0x54
    public static let kVK_ANSI_Keypad3              : CGKeyCode = 0x55
    public static let kVK_ANSI_Keypad4              : CGKeyCode = 0x56
    public static let kVK_ANSI_Keypad5              : CGKeyCode = 0x57
    public static let kVK_ANSI_Keypad6              : CGKeyCode = 0x58
    public static let kVK_ANSI_Keypad7              : CGKeyCode = 0x59
    public static let kVK_ANSI_Keypad8              : CGKeyCode = 0x5B
    public static let kVK_ANSI_Keypad9              : CGKeyCode = 0x5C
    
    // keycodes for keys that are independent of keyboard layout
    public static let kVK_Return                    : CGKeyCode = 0x24
    public static let kVK_Tab                       : CGKeyCode = 0x30
    public static let kVK_Space                     : CGKeyCode = 0x31
    public static let kVK_Delete                    : CGKeyCode = 0x33
    public static let kVK_Escape                    : CGKeyCode = 0x35
    public static let kVK_Command                   : CGKeyCode = 0x37
    public static let kVK_Shift                     : CGKeyCode = 0x38
    public static let kVK_CapsLock                  : CGKeyCode = 0x39
    public static let kVK_Option                    : CGKeyCode = 0x3A
    public static let kVK_Control                   : CGKeyCode = 0x3B
    public static let kVK_RightCommand              : CGKeyCode = 0x36 // Out of order
    public static let kVK_RightShift                : CGKeyCode = 0x3C
    public static let kVK_RightOption               : CGKeyCode = 0x3D
    public static let kVK_RightControl              : CGKeyCode = 0x3E
    public static let kVK_Function                  : CGKeyCode = 0x3F
    public static let kVK_F17                       : CGKeyCode = 0x40
    public static let kVK_VolumeUp                  : CGKeyCode = 0x48
    public static let kVK_VolumeDown                : CGKeyCode = 0x49
    public static let kVK_Mute                      : CGKeyCode = 0x4A
    public static let kVK_F18                       : CGKeyCode = 0x4F
    public static let kVK_F19                       : CGKeyCode = 0x50
    public static let kVK_F20                       : CGKeyCode = 0x5A
    public static let kVK_F5                        : CGKeyCode = 0x60
    public static let kVK_F6                        : CGKeyCode = 0x61
    public static let kVK_F7                        : CGKeyCode = 0x62
    public static let kVK_F3                        : CGKeyCode = 0x63
    public static let kVK_F8                        : CGKeyCode = 0x64
    public static let kVK_F9                        : CGKeyCode = 0x65
    public static let kVK_F11                       : CGKeyCode = 0x67
    public static let kVK_F13                       : CGKeyCode = 0x69
    public static let kVK_F16                       : CGKeyCode = 0x6A
    public static let kVK_F14                       : CGKeyCode = 0x6B
    public static let kVK_F10                       : CGKeyCode = 0x6D
    public static let kVK_F12                       : CGKeyCode = 0x6F
    public static let kVK_F15                       : CGKeyCode = 0x71
    public static let kVK_Help                      : CGKeyCode = 0x72
    public static let kVK_Home                      : CGKeyCode = 0x73
    public static let kVK_PageUp                    : CGKeyCode = 0x74
    public static let kVK_ForwardDelete             : CGKeyCode = 0x75
    public static let kVK_F4                        : CGKeyCode = 0x76
    public static let kVK_End                       : CGKeyCode = 0x77
    public static let kVK_F2                        : CGKeyCode = 0x78
    public static let kVK_PageDown                  : CGKeyCode = 0x79
    public static let kVK_F1                        : CGKeyCode = 0x7A
    public static let kVK_LeftArrow                 : CGKeyCode = 0x7B
    public static let kVK_RightArrow                : CGKeyCode = 0x7C
    public static let kVK_DownArrow                 : CGKeyCode = 0x7D
    public static let kVK_UpArrow                   : CGKeyCode = 0x7E
    
    // ISO keyboards only
    public static let kVK_ISO_Section               : CGKeyCode = 0x0A
    
    // JIS keyboards only
    public static let kVK_JIS_Yen                   : CGKeyCode = 0x5D
    public static let kVK_JIS_Underscore            : CGKeyCode = 0x5E
    public static let kVK_JIS_KeypadComma           : CGKeyCode = 0x5F
    public static let kVK_JIS_Eisu                  : CGKeyCode = 0x66
    public static let kVK_JIS_Kana                  : CGKeyCode = 0x68
    
    public var isModifier: Bool {
        return (.kVK_RightCommand...(.kVK_Function)).contains(self)
    }
    
    public var baseModifier: CGKeyCode?
    {
        if (.kVK_Command...(.kVK_Control)).contains(self)
            || self == .kVK_Function
        {
            return self
        }
        
        switch self
        {
            case .kVK_RightShift: return .kVK_Shift
            case .kVK_RightCommand: return .kVK_Command
            case .kVK_RightOption: return .kVK_Option
            case .kVK_RightControl: return .kVK_Control
                
            default: return nil
        }
    }
    
    public var isPressed: Bool {
        CGEventSource.keyState(.combinedSessionState, key: self)
    }
}
#endif
