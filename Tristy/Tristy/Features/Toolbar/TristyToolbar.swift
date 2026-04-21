
import SwiftData
import SwiftUI

struct TristyToolbar: ToolbarContent {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router
#if os(iOS)
    @Environment(\.editMode) private var editMode
#endif
        
    @Namespace private var namespace
    
    private var isEditing: Bool {
#if os(iOS)
        return (editMode?.wrappedValue.isEditing ?? false)
        || !router.selectedGroceries.isEmpty
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
    
#if os(macOS)
    let isMac = true
#else
    let isMac = false
#endif
    
    var body: some ToolbarContent {
        if isEditing || isMac {
            let selected = router.selectedGroceries
            let descriptor: FetchDescriptor<Grocery> = .init(
                predicate: #Predicate { selected.contains($0.id) }
            )
            let fetched = try? modelContext.fetch(descriptor)
            let allPinned =
            fetched?.allSatisfy { $0.isPinned || $0.listEnum != .active }
            ?? false
            let allComplete =
            !(fetched ?? []).isEmpty
            && fetched?.allSatisfy { $0.isCompleted } ?? false
            
            ToolbarSpacer(.fixed, placement: morePlacement)
            
            ToolbarItemGroup(placement: morePlacement) {
                ForEach(GroceryList.allCases) { list in
                    Button(list.name, systemImage: list.symbolName) {
                        fetched?.forEach {
                            if allPinned || !$0.isPinned
                                || $0.listEnum != .active
                            {
                                $0.setList(list)
                                router.selectedGroceries.remove($0.id)
                            }
                        }
                    }
                    .disabled(router.selectedGroceries.isEmpty)
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
                .disabled(router.selectedGroceries.isEmpty)
            }
            
#if os(macOS)
            ToolbarItem(placement: morePlacement) {
                StoresFilterMenu()
            }
#endif
        } else {
            ToolbarItemGroup(placement: morePlacement) {
                StoresFilterMenu()
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
                        let items =
                        (try? modelContext.fetch(
                            FetchDescriptor<Grocery>(
                                predicate: predicate
                            )
                        )) ?? []
                        
                        if router.selectedGroceries.count == 1 {
                            if let first = items.first {
                                router.presentSheet(
                                    .grocery(.single(first))
                                )
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
