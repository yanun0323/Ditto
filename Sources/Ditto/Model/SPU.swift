import SwiftUI
import Sparkle

public struct Updater {
    public var shared: SPUStandardUpdaterController { SPUStandardUpdaterController.shared }
}

extension SPUStandardUpdaterController {
    public static var shared = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: SPUUser.default)
}

public class SPUUser: NSObject {
    public static var `default` = SPUUser()
}

extension SPUUser: SPUStandardUserDriverDelegate {
    public var supportsGentleScheduledUpdateReminders: Bool { true }
    public func standardUserDriverShouldHandleShowingScheduledUpdate(_ update: SUAppcastItem, andInImmediateFocus immediateFocus: Bool) -> Bool {
        Debug.print("ShouldHandleShowingScheduledUpdate")
        return immediateFocus
    }
    
    public func standardUserDriverWillHandleShowingUpdate(_ handleShowingUpdate: Bool, forUpdate update: SUAppcastItem, state: SPUUserUpdateState) {
        Debug.print("WillHandleShowingUpdate")
        SPUStandardUpdaterController.shared.userDriver.showUpdateInFocus()
    }
    
    public func standardUserDriverDidReceiveUserAttention(forUpdate update: SUAppcastItem) {
        Debug.print("DidReceiveUserAttention")
    }
    
    public func standardUserDriverWillFinishUpdateSession() {
        Debug.print("WillFinishUpdateSession")
        let updater = SPUStandardUpdaterController.shared.updater
        updater.resetUpdateCycle()
    }
}
