//
//  TabView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router
    
    @AppStorage(Settings.Tabs.key) var tabSetting = Settings.Tabs.defaultValue
    
    var tabs: [TristyTab] {
        switch tabSetting {
        case .singlePage:
            [.today([.active, .nextTime, .archive])]
        case .eachAsOwn:
            [.today, .nextTime, .archive]
        case .archiveAsOwn:
            [.today, .archive]
        case .activeAsOwn:
            [.today, .archive]
        }
    }
    
    var body: some View {
        TabView(selection: router.tabBinding) {
            ForEach(TristyTab.allCases) { tab in
                Tab(
                    tab.rawValue,
                    systemImage: tab.symbolName,
                    value: tab,
                    role: tab.role,
                    content: { tab.correspondingView }
                )
            }
        }
        .applyAddBar(hasSearch: false)
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

#Preview {
    ContentView()
        .applyEnvironment()
}
