import SwiftUI
import Sparkle

@main
struct ZapClipperApp: App {
    private let updaterController: SPUStandardUpdaterController

    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(updater: updaterController.updater)
        }
        .windowResizability(.contentSize)
    }
}
