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
    
    @Environment(AddBarService.self) var addBarService
    
    @Namespace var namespace
    
    var newGroceryButton: some View {
        Button("New grocery", systemImage: "plus") { router.presentSheet(.grocery(.new)) } //NewGroceryButton()
    }
    
    
    var sharedContents: some View {
        let absQuery = Binding {
            addBarService.query
        } set: { addBarService.query = $0 }
        
        let absIsSearching = Binding {
            addBarService.isSearching
        } set: { addBarService.isSearching = $0 }

        
        return ShoppingListView(showingLists: [.active, .nextTime, .archive])
            .searchable(
                text: absQuery,
                isPresented: absIsSearching,
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
                SheetSwitchView(namespace: namespace)
                    .frame(minHeight: 360)
            }
            .onAppear {
                // Set up addBarService
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
