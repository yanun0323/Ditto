import SwiftUI

extension EnvironmentValues {
    var bundleVersion: String {
        self[BundleVersionKey.self]
    }
    
    var bundleBuild: String {
        self[BundleBuildKey.self]
    }
}

private struct BundleVersionKey: EnvironmentKey {
    static var defaultValue: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-" }
}

private struct BundleBuildKey: EnvironmentKey {
    static var defaultValue: String { Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-" }
}
    
#if os(iOS) || os(macOS) || os(watchOS)
extension EnvironmentValues {
    var device: Device {
        self[DeviceKey.self]
    }
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
    
    var safeArea: CGSize {
        self[SafeAreaKey.self]
    }
    
    var homebarArea: CGSize {
        self[HomebarAreaKey.self]
    }
    
    var statusbarArea: CGSize {
        self[StatusbarAreaKey.self]
    }
}

private struct DeviceKey: EnvironmentKey {
    static var defaultValue: Device { .init() }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets { Device.safeAreaInsets }
}

private struct SafeAreaKey: EnvironmentKey {
    static var defaultValue: CGSize { Device.safeArea }
}

private struct HomebarAreaKey: EnvironmentKey {
    static var defaultValue: CGSize { Device.homebarArea }
}

private struct StatusbarAreaKey: EnvironmentKey {
    static var defaultValue: CGSize { Device.statusbarArea }
}
#endif
