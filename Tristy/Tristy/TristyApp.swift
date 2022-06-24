//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 6/24/22.
//

import SwiftUI

@main
struct TristyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
