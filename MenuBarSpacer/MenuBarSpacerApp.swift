import SwiftUI

@main
struct MenuBarSpacerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 300)
        }
        .windowResizability(.contentSize)
    }
}
