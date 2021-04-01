//
//  FrutaApp
//  Fruta
//

import SwiftUI

@main
struct FrutaApp: App {
    @StateObject private var model = FrutaModel()
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(store)
        }
        .commands {
            SidebarCommands()
        }
    }
}
