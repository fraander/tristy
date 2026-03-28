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
    @Environment(\.modelContext) var modelContext
    
    @State var addBarService = AddBarService()
    
    @Namespace var namespace
    
    var body: some View {
        NavigationView {
            ShoppingListView(showingLists: [.active, .nextTime, .archive])
                .searchable(
                    text: $addBarService.query,
                    isPresented: $addBarService.isSearching
                )
                .onSubmit(of: .search) {
                    let newGrocery = Grocery(
                        list: .active,
                        title: addBarService.trimmedQuery
                    )
                    modelContext.insert(newGrocery)
                }
                .overlay (alignment: .bottom) {
                    AddBarSuggestions(addBarService: addBarService)
                        .padding(.bottom, addBarService.isSearching ? 80 : 0)
                }
                .animation(
                    .default,
                    value: addBarService.isSearching
                )
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
        .onAppear {
            addBarService.modelContext = modelContext
            addBarService.fetchGroceries()
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
