import SwiftUI
import Sparkle

public struct Updater {
    public static func checkForUpdate() {
        SPUStandardUpdaterController.shared.updater.checkForUpdates()
    }
    
    public static func checkForUpdateSchedule(_ interval: TimeInterval = .day) {
        if let last = SPUStandardUpdaterController.shared.updater.lastUpdateCheckDate, Date.now < last.addingTimeInterval(interval) { return }
        SPUStandardUpdaterController.shared.updater.checkForUpdatesInBackground()
    }
    
    public static var shared: SPUStandardUpdaterController { SPUStandardUpdaterController.shared }
}

extension SPUStandardUpdaterController {
    public static var shared = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: SPUUser.default)
}

extension SPUStandardUpdaterController {
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
