import SwiftUI
import SwiftData

struct TristyToolbar: ToolbarContent {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router
    #if os(iOS)
    @Environment(\.editMode) private var editMode
    #endif

    @Query(sort: [SortDescriptor(\GroceryStore.sortOrder, order: .forward)]) var stores: [GroceryStore]
    @SceneStorage("storeFilter") private var storeFilter: [String] = []

    @Namespace private var namespace

    private var isEditing: Bool {
        #if os(iOS)
        return (editMode?.wrappedValue.isEditing ?? false) || !router.selectedGroceries.isEmpty
        #else
        return !router.selectedGroceries.isEmpty
        #endif
    }

    private var morePlacement: ToolbarItemPlacement {
        #if os(iOS)
        return .topBarTrailing
        #else
        return .automatic
        #endif
    }

    var body: some ToolbarContent {
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
                                    store.nameOrEmpty
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
                                    "No store"
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

            ToolbarSpacer(placement: morePlacement)
        }

        #if os(iOS)
        if !isEditing {
            ToolbarItem(placement: .topBarLeading) {
                Button("Settings", systemImage: Symbols.settings) {
                    router.presentSheet(.settings)
                }
                .matchedTransitionSource(id: "settings", in: namespace)
            }
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Button("Info", systemImage: Symbols.info) {
                    if !router.selectedGroceries.isEmpty {
                        
                        let r = router.selectedGroceries
                        let predicate = #Predicate<Grocery> { grocery in
                            r.contains(grocery.persistentModelID)
                        }
                        let items = (try? modelContext.fetch(FetchDescriptor<Grocery>(predicate: predicate))) ?? []
                        
                        if router.selectedGroceries.count == 1 {
                            if let first = items.first {
                                router.presentSheet(.grocery(.single(first)))
                            }
                        } else if router.selectedGroceries.count > 1 {
                            router.presentSheet(.grocery(.bulk(items)))
                        }
                    }
                }
                .disabled(router.selectedGroceries.isEmpty)
            }
        }

        ToolbarSpacer(.fixed, placement: .topBarLeading)

        ToolbarItem(placement: .topBarLeading) {
            EditButton()
        }
        #endif
    }
}
