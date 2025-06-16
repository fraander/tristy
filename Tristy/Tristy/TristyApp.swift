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
            #if os(iOS)
            ContentView()
                .applyEnvironment(router: router, abStore: abStore)
            #else
            MacContentView()
                .applyEnvironment(router: router, abStore: abStore)
            #endif
        }
        
#if os(macOS)
        SwiftUI.Settings {
            SettingsView()
                .applyEnvironment(router: router, abStore: abStore)
        }
#endif
    }
}
