//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(\.editMode) var editMode
    @Environment(\.modelContext) var modelContext
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
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false || !selectedGroceries.isEmpty
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
                if isEditing {
                    
                    let descriptor: FetchDescriptor<Grocery> = .init(predicate: #Predicate { selectedGroceries.contains($0.id) } )
                    let fetched = try? modelContext.fetch(descriptor)
                    let result = fetched?.allSatisfy { $0.isCompleted } ?? false
                    
                    ToolbarItemGroup(placement: morePlacement) {
                            ForEach(GroceryList.allCases) { list in
                                Button(list.name, systemImage: list.symbolName) {
                                    fetched?.forEach {
                                        $0.setList(list)
                                        selectedGroceries.remove($0.id)
                                    }
                                }
                            }
                    }
                    
                    ToolbarSpacer(.fixed, placement: morePlacement)
                    
                    ToolbarItem(placement: morePlacement) {
                        
                        Button("Toggle completed", systemImage: "checkmark.circle") {
                            fetched?.forEach {
                                $0.setCompleted(to: !result)
                                selectedGroceries.remove($0.id)
                            }
                        }
                        .symbolVariant(result ? .fill : .none)
                        .tint(result ? .mint : .accent)
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
                    Button("Settings", systemImage: "gear") { router.presentSheet(.settings) }
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
