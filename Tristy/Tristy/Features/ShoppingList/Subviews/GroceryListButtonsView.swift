//  GroceryListButtonsView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI
import SwiftData

struct GroceryListButtonsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    
    var grocery: Grocery
    
    let shouldMoveAllSelectedOnTap: Bool = false
    var relevantLists: [GroceryList] {
        // get the grocery list of all relevant groceries
        let x = Set(relevantGroceries.map(\.listEnum))
        // if they all come from one list, exclude that list (nowhere else to move "into")
        // otherwise (mixed lists, or none), any list is a valid destination
        return x.count == 1 ? GroceryList.allCases.filter { $0 != x.first } : GroceryList.allCases
    }
    
    var relevantGroceries: [Grocery] {
        if shouldMoveAllSelectedOnTap {
            // snapshot the currently selected grocery IDs
            let r = router.selectedGroceries
            // fetch the actual Grocery objects matching those selected IDs
            let predicate = #Predicate<Grocery> { grocery in
                r.contains(grocery.persistentModelID)
            }
            let items = (try? modelContext.fetch(FetchDescriptor<Grocery>(predicate: predicate))) ?? []
            
            // combine selected items with the tapped grocery, deduping in case it's already selected
            return Array(Set(items + [grocery]))
        } else {
            // no multi-select active; only the tapped grocery is relevant
            return [grocery]
        }
    }
    
    var body: some View {
        Group {
            ForEach(relevantLists) { gList in
                Button(gList.name, systemImage: gList.symbolName) {
                    withAnimation {
                        relevantGroceries.forEach { $0.setList(gList) }
                    }
                }
                .tint(gList.color)
            }
        }
    }
}
