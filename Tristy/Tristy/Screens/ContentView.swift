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
        TabView(selection: router.tabBinding) {
            ForEach(tabs) { tab in
                Tab(
                    tab.rawValue,
                    systemImage: tab.symbolName,
                    value: tab,
                    role: tab.role,
                    content: { tab.correspondingView }
                )
            }
            
            Tab(value: TristyTab.search, role: .search) {
                Text("Error")
            }
        }
        .toolbar(tabs.count > 1 ? .visible : .hidden, for: .tabBar)
        .fabBar(
            selection: router.tabBinding,
            tabs: fabs,
            action: .init(
                systemImage: "cart.badge.plus",
                accessibilityLabel: "Prepare trip",
                action: {
                    #warning("This should show a list of all items in Next Time and Archive where you click the plus button; and have a searchable to quickly find stuff")
                    #warning("Alternatively, get rid of this and just use a Searchable instead of the AddBar and add the same behaviors")
                    print("testing")
                }
            ),
            //isVisible: fabs.count > 1
        )
        .tabViewStyle(.sidebarAdaptable)
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
