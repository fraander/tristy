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
        NavigationStack {
            ZStack {
                #if os(iOS)
                BackgroundView(color: .accent)
                #endif
                
                contents
//                    .onChange(of: selectedGroceries) { oldValue, newValue in
//                        #if os(iOS)
//                        if !(editMode?.wrappedValue.isEditing ?? false) {
//                            selectedGroceries.removeAll()
//                        }
//                        #endif
//                    }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
#if os(iOS)
                    .navigationTransition(.zoom(sourceID: "settings", in: namespace))
                #endif
            }
            .sheet(isPresented: $showNewGrocery) {
                GroceryDetailView(grocery: nil)
#if os(iOS)
                    .navigationTransition(.zoom(sourceID: "newGrocery", in: namespace))
                #endif
            }
            .toolbar {
                if isEditing {
                    
                    let selected = router.selectedGroceries
                    let descriptor: FetchDescriptor<Grocery> = .init(predicate: #Predicate { selected.contains($0.id) } )
                    let fetched = try? modelContext.fetch(descriptor)
                    let allPinned = fetched?.allSatisfy { $0.isPinned || $0.listEnum != .active } ?? false
                    let allComplete = fetched?.allSatisfy { $0.isCompleted } ?? false
                    
                    ToolbarSpacer(.fixed, placement: morePlacement)
                    
                    ToolbarItemGroup(placement: morePlacement) {
                        ForEach(GroceryList.allCases) { list in
                            Button(list.name, systemImage: list.symbolName) {
                                fetched?.forEach {
                                    if allPinned || !$0.isPinned || $0.listEnum != .active {
                                        $0.setList(list)
                                        router.selectedGroceries.remove($0.id)
                                    }
                                }
                            }
                        }
                    }
                    
                    ToolbarSpacer(.fixed, placement: morePlacement)
                    
                    ToolbarItem(placement: morePlacement) {
                        
                        Button("Toggle completed", systemImage: Symbols.complete) {
                            fetched?.forEach {
                                $0.setCompleted(to: !allComplete)
                                router.selectedGroceries.remove($0.id)
                            }
                        }
                        .symbolVariant(.circle)
                        .symbolVariant(allComplete ? .fill : .none)
                        .tint(allComplete ? .mint : .accent)
                    }
                } else {
                    
                    ToolbarItemGroup(placement: morePlacement) {
                        if !stores.isEmpty {
                            Menu {
                                ForEach(stores) { store in
                                    if storeFilter.contains(store.nameOrEmpty) {
                                        Button(
                                            store.nameOrEmpty,
                                            systemImage: "checkmark"
                                        ) {
                                            storeFilter.removeAll { $0 == store.nameOrEmpty }
                                        }
                                        .foregroundStyle(store.colorOrDefault)
                                    } else {
                                        Button(
                                            store.nameOrEmpty,
                                        ) {
                                            storeFilter += [store.nameOrEmpty]
                                            
                                        }
                                        .foregroundStyle(store.colorOrDefault)
                                    }
                                }
                                
                                if stores.count > 0 {
                                    if storeFilter.contains("") {
                                        Button(
                                            "No store",
                                            systemImage: "checkmark"
                                        ) {
                                            storeFilter.removeAll { $0 == "" }
                                        }
                                        .foregroundStyle(.secondary)
                                    } else {
                                        Button(
                                            "No store",
                                        ) {
                                            storeFilter += [""]
                                            
                                        }
                                        .foregroundStyle(.secondary)
                                    }
                                }
                                
                                if storeFilter.count > 0 {
                                    Divider()
                                    
                                    Button("Clear filter", systemImage: "line.3.horizontal.decrease.circle") {
                                        storeFilter = []
                                    }
                                }
                            } label: {
                                Label("Filter",
                                      systemImage: Symbols.filter)
                                .symbolVariant(.circle)
                                .symbolVariant(storeFilter.isEmpty ? .none : .fill)
                            }
                            .contentTransition(.symbolEffect)
#if os(macOS)
                            .menuStyle(.button)
#endif
                        }
                    }
                    
                    ToolbarSpacer(placement: morePlacement)
                    
                    ToolbarItemGroup(placement: morePlacement) {
                        Button("Plus", systemImage: Symbols.add) {
                            showNewGrocery = true
//                            router.presentSheet(.newGrocery)
                        }
                        .matchedTransitionSource(id: "newGrocery", in: namespace)
                    }
                }
                
#if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    Button("Settings", systemImage: Symbols.settings) {
                        showSettings = true
                    }
                    .matchedTransitionSource(id: "settings", in: namespace)
                }
                
                ToolbarSpacer(.fixed, placement: .topBarLeading)
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                    #warning("In edit mode, hide settings icon; add a 'bulk actions' menu to right of edit button")
                }
#endif
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .list([.active, .nextTime])))
}
