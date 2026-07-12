//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import CloudKitSyncMonitor
import SwiftData
import SwiftUI

@main
struct TristyApp: App {

    let container: ModelContainer

    init() {
        let config = ModelConfiguration(
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )
        container = try! ModelContainer(
            for: Grocery.self,
            GroceryStore.self,
            configurations: config
        )

        SyncMonitor.default.startMonitoring()

    }
    
    @FocusedValue(Router.self) var focusedRouter: Router?
    @FocusedValue(AddBarService.self) var addBarService: AddBarService?

    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        WindowGroup(id: "main") {
            AppView()
                .modelContainer(container)
                #if os(macOS)
                    .task {
                        NSWindow.allowsAutomaticWindowTabbing = false
                    }
                #endif
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Window") {
                    openWindow(id: "main")
                }
                
                Button("Create New Grocery") {
                    // focus router.new
                    focusedRouter?.presentSheet(.grocery(.new))
                }
                .disabled(focusedRouter == nil)
                .keyboardShortcut("n", modifiers: [.command, .shift])
                
                Button("Add Grocery to List") {
                    // focus add bar
                    addBarService?.isSearching = true
                }
                .disabled(addBarService == nil)
                .keyboardShortcut("n", modifiers: [.command])
            }
        }
        #if os(macOS)
            SwiftUI.Settings {  // <-- this window cannot be resized freely, why?
                SettingsView()
                    .modelContainer(container)
            }
            .windowToolbarStyle(.unifiedCompact)
            .defaultSize(width: 480, height: 600)
        #endif
    }
}
