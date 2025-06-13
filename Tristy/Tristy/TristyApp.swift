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
    
    init() {
        SyncMonitor.default.startMonitoring()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyEnvironment()
        }
    }
}
