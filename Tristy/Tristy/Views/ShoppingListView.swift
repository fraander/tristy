//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

#warning("let user pick if next time is its own tab or not.")
#warning("let user filter list by store; sort by store.")
#warning("upgrade the 'sort by' UI in settings - one multi-picker, not many toggles; reordering not yet required though.")

struct ShoppingListView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    @State var selectedGroceries: Set<PersistentIdentifier> = []
    
#if os(iOS)
    @Environment(\.editMode) var editMode
#endif
    
    var contents: some View {
        List(selection: $selectedGroceries) {
            GroceryListSection(list: .active, isExpanded: true, selectedGroceries: $selectedGroceries)
            GroceryListSection(list: .nextTime, isExpanded: false, selectedGroceries: $selectedGroceries)
#if os(iOS)
                .listSectionMargins(.bottom, 120)
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
            }
            .navigationTitle(TristyTab.today.rawValue)
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
        .environment(Router.init(tab: .today))
        .applyEnvironment(prePopulate: true)
}
