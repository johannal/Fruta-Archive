//
//  FrutaApp.swift
//  Fruta
//

import SwiftUI
#if !os(macOS)
import HealthKit
#endif

@main
struct FrutaApp: App {
    
    @StateObject var dataStore = FrutaModel()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
                .onAppear {
                    #if os(iOS)
                    if CommandLine.arguments.contains("-enable-healthkit") {
                        let burnedCalories = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
                        HKHealthStore().requestAuthorization(toShare: nil,
                                                             read: burnedCalories) { _, _ in }
                    }
                    #endif
            }
        }
    }
}
