//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(Router.self) var router
    @State var selectedGroceries: Set<PersistentIdentifier> = []
    
    var contents: some View {
        List(selection: $selectedGroceries) {
            GroceryListSection(list: .active, isExpanded: true, selectedGroceries: $selectedGroceries)
            GroceryListSection(list: .nextTime, isExpanded: false, selectedGroceries: $selectedGroceries)
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .accent)
                
                contents
            }
            .navigationTitle(TristyTab.today.rawValue)
            .toolbar {
                ToolbarItemGroup(placement: morePlacement) {
                    Button("Plus", systemImage: Symbols.add) {
                        router.presentSheet(.newGrocery)
                    }
                    Menu("More", systemImage: Symbols.more) {
                        Settings.HideCompleted.Toggle()
                        Settings.CollapsibleSections.Toggle()
                        Settings.CompletedToBottom.Toggle()
                        Settings.AddBarSuggestions.Toggle()
                    }
                }
                
                #if os(iOS)
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") { router.presentSheet(.settings) }
                    
                    #warning("add actions to the toolbar when edit mode is engaged")
                    EditButton()
                        .labelStyle(.iconOnly)
                }
                #endif
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .today))
        .applyEnvironment(prePopulate: true)
}
