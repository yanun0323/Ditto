import SwiftUI

public enum Layout {
    case center
    case top
    case bottom
    case leading
    case trailing
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    
    case horizontalCenter
    case verticalCenter
}

fileprivate extension Layout {
    var topSpacer: Bool {
        switch self {
        case .center, .verticalCenter, .bottom, .bottomLeading, .bottomTrailing:
            true
        default:
            false
        }
    }
    
    var bottomSpacer: Bool {
        switch self {
        case .center, .verticalCenter, .top, .topLeading, .topTrailing:
            true
        default:
            false
        }
    }
    
    var leadingSpacer: Bool {
        switch self {
        case .center, .horizontalCenter, .trailing, .topTrailing, .bottomTrailing:
            true
        default:
            false
        }
    }
    
    var trailingSpacer: Bool {
        switch self {
        case .center, .horizontalCenter, .leading, .topLeading, .bottomLeading:
            true
        default:
            false
        }
    }
}

extension View {
    public func push(_ layout: Layout) -> some View {
        VStack(spacing: 0) {
            ConditionSpacer(visible: layout.topSpacer)
            HStack(spacing: 0) {
                ConditionSpacer(visible: layout.leadingSpacer)
                self
                ConditionSpacer(visible: layout.trailingSpacer)
            }
            ConditionSpacer(visible: layout.bottomSpacer)
        }
    }
}
