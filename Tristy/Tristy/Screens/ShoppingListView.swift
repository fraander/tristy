//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
#warning("Add by-store grouping with folds; 2nd level list (and turn on off in settings)")
    
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    
    @Query var stores: [GroceryStore]
    @SceneStorage("storeFilter") var storeFilter: [String] = []
    
    var showingLists: [GroceryList]
    
#if os(iOS)
    @Environment(\.editMode) var editMode
#endif
    
    var contents: some View {
        List(selection: router.selectedGroceriesBinding) {
            ForEach(showingLists) { l in
                GroceryListSection(
                    list: l,
                    isExpanded: l == showingLists.first || showingLists.count == 1,
                    canExpand: showingLists.count != 1,
                )
#if os(iOS)
                .listSectionMargins(.bottom, l == showingLists.last ? 120 : 20)
#endif
            }
#if os(iOS)
#endif
        }
        .scrollContentBackground(.hidden)
        //        .listStyle(.plain)
    }
    
    var isEditing: Bool {
#if os(iOS)
        editMode?.wrappedValue.isEditing ?? false || !router.selectedGroceries.isEmpty
#else
        !selectedGroceries.isEmpty
#endif
    }
    
    var morePlacement: ToolbarItemPlacement {
#if os(iOS)
        .topBarTrailing
#else
        .automatic
#endif
    }
    
    @State var showNewGrocery = false
    @State var showSettings = false
    @Namespace var namespace
    
    var body: some View {
        ZStack {
#if os(iOS)
            BackgroundView(color: .accent)
#endif
            
            contents
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init())
}
