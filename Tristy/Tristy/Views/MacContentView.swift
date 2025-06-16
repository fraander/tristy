//
//  TabView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct MacContentView: View {
    
    @Environment(Router.self) var router
    
    
    var body: some View {
        NavigationSplitView {
            List(TristyTab.allCases) { tab in
                Button(tab.rawValue, systemImage: tab.symbolName) {
                    router.setTab(to: tab)
                }
            }
            .listStyle(.sidebar)
        } detail: {
            router.tab.correspondingView
        }
        .overlay(alignment: .bottom) {
            VStack {
                AddBarList()
                AddBarTextField()
            }
        }
        .sheet(isPresented: router.sheetBinding) {
            Group {
                if let sheet = router.sheet {
                    switch sheet {
                    case .settings: SettingsView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
