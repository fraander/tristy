//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI
import CloudKitSyncMonitor

@main
struct TristyApp: App {
    
    
    @State var router = Router()
    @State var abStore = AddBarStore()
    
    init() {
        SyncMonitor.default.startMonitoring()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyEnvironment(router: router, abStore: abStore)
#if os(macOS)
                .task {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
#endif
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New grocery", systemImage: Symbols.add) { router.presentSheet(.newGrocery) }
                    .keyboardShortcut("n", modifiers: .command)
            }
        }
        
#if os(macOS)
        SwiftUI.Settings {
            SettingsView()
                .applyEnvironment(router: router, abStore: abStore)
        }
#endif
    }
}
