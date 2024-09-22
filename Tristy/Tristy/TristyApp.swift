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
#if os(macOS)
                .frame(minWidth: 450, idealWidth: 450, minHeight: 200, idealHeight: 600)
#endif
                .modelContainer(for: Grocery.self)
                .task {
//#if DEBUG
//                    try? Tips.resetDatastore()
//#endif
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
