//
//  FrutaApp
//  Fruta
//

import SwiftUI

@main
struct FrutaApp: App {
    @StateObject private var model = FrutaModel()
    
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
