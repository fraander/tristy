//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct ShoppingListView: View {
    
    @Environment(Router.self) var router
    
    var contents: some View {
        List {
            GroceryListSection(list: .active, isExpanded: true)
            GroceryListSection(list: .nextTime, isExpanded: false)
            #if os(iOS)
                .listSectionMargins(.bottom, 120)
            #endif
        }
        .scrollContentBackground(.hidden)
    }
    
    var morePlacement: ToolbarItemPlacement {
#if os(iOS)
        .topBarTrailing
#else
        .automatic
#endif
    }
    
    var settingsPlacement: ToolbarItemPlacement {
#if os(iOS)
        .topBarLeading
#else
        .automatic
#endif
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .accent)
                
                contents
            }
            .navigationTitle(TristyTab.today.rawValue)
            .toolbar {
                ToolbarItemGroup(placement: morePlacement) {
                    Menu("More", systemImage: Symbols.more) {
                        Settings.HideCompleted.Toggle()
                        Settings.CollapsibleSections.Toggle()
                        Settings.CompletedToBottom.Toggle()
                        Settings.AddBarSuggestions.Toggle()
                    }
                }
                
                ToolbarItemGroup(placement: settingsPlacement) {
                    Button("Settings", systemImage: "gear") { router.presentSheet(.settings) }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .today))
        .applyEnvironment(prePopulate: true)
}
