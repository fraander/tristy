//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    @State var selectedGroceries: Set<PersistentIdentifier> = []
    
    @Query var stores: [GroceryStore]
    @SceneStorage("storeFilter") var storeFilter: [String] = []
    
    var showingLists: [GroceryList]
    
#if os(iOS)
    @Environment(\.editMode) var editMode
#endif
    
    var contents: some View {
        List(selection: $selectedGroceries) {
            ForEach(showingLists) { l in
                GroceryListSection(
                    list: l,
                    isExpanded: l == showingLists.first || showingLists.count == 1,
                    canExpand: showingLists.count != 1,
                    selectedGroceries: $selectedGroceries
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
        editMode?.wrappedValue.isEditing ?? false || !selectedGroceries.isEmpty
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                #if os(iOS)
                BackgroundView(color: .accent)
                #endif
                
                contents
                    .onChange(of: selectedGroceries) { oldValue, newValue in
                        #if os(iOS)
                        if !(editMode?.wrappedValue.isEditing ?? false) {
                            selectedGroceries.removeAll()
                        }
                        #endif
                    }
            }
            .toolbar {
                if isEditing {
                    
                    let descriptor: FetchDescriptor<Grocery> = .init(predicate: #Predicate { selectedGroceries.contains($0.id) } )
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
                                        selectedGroceries.remove($0.id)
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
                                selectedGroceries.remove($0.id)
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
                                            storeFilter = []
                                        }
                                        .foregroundStyle(store.colorOrDefault)
                                    } else {
                                        Button(
                                            store.nameOrEmpty,
                                        ) {
                                            storeFilter = [store.nameOrEmpty]
                                            
                                        }
                                        .foregroundStyle(store.colorOrDefault)
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
                            router.presentSheet(.newGrocery)
                        }
                    }
                }
                
#if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    Button("Settings", systemImage: Symbols.settings) { router.presentSheet(.settings) }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarLeading)
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
#endif
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .list([.active, .nextTime])))
        .applyEnvironment(prePopulate: true)
}
