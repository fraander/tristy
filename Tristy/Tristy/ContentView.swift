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
    
    @AppStorage(Settings.MinimizeAddBar.key) var minimizeAddBar: Bool = Settings.MinimizeAddBar.defaultValue
    
    @State var addBarService = AddBarService()
    
    @Namespace var namespace
    
    var newGroceryButton: some View {
        Button("New grocery", systemImage: "plus") { router.presentSheet(.grocery(.new)) } //NewGroceryButton()
    }
    
    
    var sharedContents: some View {
        ShoppingListView(showingLists: [.active, .nextTime, .archive])
            .searchable(
                text: $addBarService.query,
                isPresented: $addBarService.isSearching,
                prompt: Text("Add groceries ...")
            )
            .onSubmit(of: .search) {
                let newGrocery = Grocery(
                    list: .active,
                    title: addBarService.trimmedQuery
                )
                modelContext.insert(newGrocery)
            }
        #if os(iOS)
            .overlay (alignment: .bottom) {
                AddBarSuggestions(addBarService: addBarService)
                    .padding(.bottom, addBarService.isSearching ? 80 : 0)
            }
        #else
            .overlay (alignment: .topTrailing) {
                AddBarSuggestions(addBarService: addBarService)
            }
        #endif
            .animation(
                .default,
                value: addBarService.isSearching
            )
        #if os(iOS)
            .searchToolbarBehavior(minimizeAddBar ? .minimize : .automatic)
        #endif
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .toolbar {
                TristyToolbar()
#if os(iOS)
                DefaultToolbarItem(kind: .search, placement: .bottomBar)
                ToolbarSpacer(.flexible, placement: .bottomBar)
                ToolbarItem(placement: .bottomBar) {
                    newGroceryButton
                }
#endif
            }
            .sheet(isPresented: router.sheetBinding) {
                Group {
                    if let sheet = router.sheet {
                        switch sheet {
                        case .settings: SettingsView()
#if os(iOS)
                                .navigationTransition(.zoom(sourceID: "settings", in: namespace))
                            #endif
                        case .grocery(let type): GroceryDetailView(type: type)
                        }
                    }
                }
                .frame(minHeight: 360)
            }
            .onAppear {
                addBarService.modelContext = modelContext
                addBarService.fetchGroceries()
            }
    }
    
    var body: some View {
        #if os(iOS)
        NavigationStack {
            sharedContents
        }
        #else
        sharedContents
        #endif
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
