//
//  TabView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(Router.self) var router
    
    @Query var groceries: [Grocery]
    @State var query: String = ""
    @State var isShowingSearch: Bool = false
    
    @Namespace var namespace
    
    var filteredItems: [Grocery] {
        AddBarService.findClosestGroceries(for: query, in: groceries)
    }
    
    var body: some View {
        NavigationView {
            ShoppingListView(showingLists: [.active, .nextTime, .archive])
                .searchable(
                    text: $query,
                    isPresented: $isShowingSearch
                )
                .overlay (alignment: .bottom) {
                    AddBarSuggestions(filteredItems: filteredItems, query: $query, isSearching: $isShowingSearch)
                }
                .animation(.default, value: isShowingSearch)
                .searchToolbarBehavior(.minimize)
                .searchPresentationToolbarBehavior(.avoidHidingContent)
                .toolbar {
                    TristyToolbar()
                    
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        Button("New grocery", systemImage: "plus") { router.presentSheet(.newGrocery) } //NewGroceryButton()
                    }
                }
                .sheet(isPresented: router.sheetBinding) {
                    Group {
                        if let sheet = router.sheet {
                            switch sheet {
                            case .settings: SettingsView().navigationTransition(.zoom(sourceID: "settings", in: namespace))
                            case .groceryInfo(let grocery): GroceryDetailView(grocery: grocery)
                            case .newGrocery:
                                GroceryDetailView(grocery: nil).navigationTransition(.zoom(sourceID: "newGrocery", in: namespace))
                            }
                        }
                    }
                    .frame(minHeight: 360)
                }
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
