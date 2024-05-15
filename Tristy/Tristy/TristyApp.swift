//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//
import TipKit
import SwiftUI

@main
struct TristyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Grocery.self)
                .task {
                    #if DEBUG
                    try? Tips.resetDatastore()
                    #endif
                    try? Tips.configure([
                        .displayFrequency(.daily),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
