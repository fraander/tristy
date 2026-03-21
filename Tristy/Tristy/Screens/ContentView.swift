//
//  TabView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import FabBar
import SwiftUI

struct ContentView: View {
    @Environment(Router.self) var router
    
    @AppStorage(Settings.Tabs.key) var tabSetting = Settings.Tabs.defaultValue
    
    var tabs: [TristyTab] {
        switch tabSetting {
        case .singlePage:
            [
                .list([.active, .nextTime, .archive])
            ]
        case .eachAsOwn:
            [
                .list([.active]),
                .list([.nextTime]),
                .list([.archive])
            ]
        case .archiveAsOwn:
            [
                .list([.active, .nextTime]),
                .list([.archive])
            ]
        case .activeAsOwn:
            [
                .list([.active]),
                .list([.nextTime, .archive])
            ]
        }
    }
    
    var fabs: [FabBarTab<TristyTab>] {
        tabs.map { tristyTab in
            FabBarTab(
                value: tristyTab,
                title: tristyTab.rawValue,
                systemImage: tristyTab.symbolName
            )
        }
    }
    
    var body: some View {
        ShoppingListView(showingLists: [.active, .nextTime, .archive])
        .sheet(isPresented: router.sheetBinding) {
            Group {
                if let sheet = router.sheet {
                    switch sheet {
                    case .settings: SettingsView()
                    case .groceryInfo(let grocery): GroceryDetailView(grocery: grocery)
                    case .newGrocery:
                        GroceryDetailView(grocery: nil)
                    }
                }
            }
            .frame(minHeight: 360)
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
