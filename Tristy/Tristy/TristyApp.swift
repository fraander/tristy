//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//
import SwiftUI

@main
struct TristyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .modelContainer(for: Grocery.self)
            }
        }
    }
}
