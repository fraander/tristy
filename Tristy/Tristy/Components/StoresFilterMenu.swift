//
//  StoresFilterMenu.swift
//  Tristy
//
//  Created by frank on 4/20/26.
//


import SwiftData
import SwiftUI

struct StoresFilterMenu: View {
    
    @Query(sort: [SortDescriptor(\GroceryStore.sortOrder, order: .forward)]) var stores: [GroceryStore]
    @Query var groceries: [Grocery]
    @SceneStorage("storeFilter") private var storeFilter: [String] = []

    func countGroceriesForStore(_ store: GroceryStore) -> Int {
        store.groceries?.filter { grocery in
            grocery.listEnum == .active
        }.count ?? 0
    }
    
    func countGroceriesWithNoStore() -> Int {
        groceries.filter { grocery in
            grocery.listEnum == .active && grocery.store == nil
        }.count
    }
    
    var body: some View {
        Group {
            if !stores.isEmpty {
                Menu {
                    ForEach(stores) { store in
                        Group {
                            if storeFilter.contains(store.nameOrEmpty) {
                                Button(
                                    store.nameOrEmpty,
                                    systemImage: "checkmark"
                                ) {
                                    storeFilter.removeAll {
                                        $0 == store.nameOrEmpty
                                    }
                                }
                                .foregroundStyle(store.colorOrDefault)
                                .badge(store.groceries?.count ?? 0)
                            } else {
                                Button(
                                    store.nameOrEmpty
                                ) {
                                    storeFilter += [store.nameOrEmpty]
                                }
                                .foregroundStyle(store.colorOrDefault)
                            }
                        }
                        .badge(countGroceriesForStore(store))
                    }
                    
                    if stores.count > 0 {
                        Group {
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
                                    "No store"
                                ) {
                                    storeFilter += [""]
                                }
                                .foregroundStyle(.secondary)
                            }
                        }
                        .badge(countGroceriesWithNoStore())
                    }
                    
                    if storeFilter.count > 0 {
                        Divider()
                        Button(
                            "Clear filter",
                            systemImage: "line.3.horizontal.decrease.circle"
                        ) {
                            storeFilter = []
                        }
                    }
                } label: {
                    Label("Filter", systemImage: Symbols.filter)
                        .symbolVariant(.circle)
                        .symbolVariant(storeFilter.isEmpty ? .none : .fill)
                }
                .contentTransition(.symbolEffect)
#if os(macOS)
                .menuStyle(.button)
#endif
            }
        }
    }
}