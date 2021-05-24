//
//  FrutaApp
//  Fruta
//

import SwiftUI

@main
struct FrutaApp: App {
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .commands {
            SidebarCommands()
        }
    }
}
