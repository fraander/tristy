//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import CloudKitSyncMonitor
import SwiftData
import SwiftUI

struct AppView: View {

    @State var router = Router()
    @State var abStore = AddBarStore()

    var body: some View {
        ContentView()
            .environment(router)
            .environment(abStore)
            .focusedSceneValue(\.router, router)
    }
}

struct RouterKey: FocusedValueKey {
    typealias Value = Router
}

extension FocusedValues {
    var router: Router? {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}

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
    
    @FocusedValue(\.router) private var router

    var body: some Scene {
        WindowGroup {
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
                Button("New grocery", systemImage: Symbols.add) {
                    router?.presentSheet(.newGrocery)
                }
                .keyboardShortcut("n", modifiers: .command)
                .disabled(router == nil)
            }
        }
        #if os(macOS)
            SwiftUI.Settings {  // <-- this window cannot be resized freely, why? please fix.
                SettingsView()
                    .modelContainer(container)
            }
            .windowToolbarStyle(.unifiedCompact)
            .defaultSize(width: 480, height: 600)
        #endif
    }
}
