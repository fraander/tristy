//
//  TabView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router
    
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
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
