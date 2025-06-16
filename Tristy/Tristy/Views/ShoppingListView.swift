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
                .listSectionMargins(.bottom, 120)
        }
        .scrollContentBackground(.hidden)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .accent)
                
                contents
            }
            .navigationTitle(TristyTab.today.rawValue)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
//                    Settings.HideCompleted.Button()
                    
                    Menu("More", systemImage: Symbols.more) {
                        Settings.HideCompleted.Toggle()
                        Settings.CollapsibleSections.Toggle()
                        Settings.CompletedToBottom.Toggle()
                        Settings.AddBarSuggestions.Toggle()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") { router.presentSheet(.settings) }
                    
//                    Settings.AddBarSuggestions.Button()
                    
                    
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
