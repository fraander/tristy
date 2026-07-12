//  GroceryListButtonsView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI
import SwiftData

struct GroceryListButtonsView: View {
    @Environment(\.groceryList) var list
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    
    var body: some View {
        Group {
            ForEach(GroceryList.allCases) { gl in
                if !listInSelection(gl) {
                    Button {
                        let selected = router.selectedGroceries
                        let descriptor: FetchDescriptor<Grocery> = .init(
                            predicate: #Predicate { selected.contains($0.id) }
                        )
                        let fetched = try? modelContext.fetch(descriptor)
                        
                        fetched?.forEach { grocery in
                            grocery.setList(gl)
                        }
                    } label: {
                        Label("Move to \(gl.name)", systemImage: gl.symbolName)
                    }
                    .tint(gl.color)
                }
            }
        }
    }
    
    private func listInSelection(_ list: GroceryList) -> Bool {
        let selected = router.selectedGroceries
        let descriptor: FetchDescriptor<Grocery> = .init(
            predicate: #Predicate { selected.contains($0.id) }
        )
        guard let fetched = try? modelContext.fetch(descriptor) else { return false }
        
        return fetched.contains { grocery in
            grocery.listEnum == list
        }
    }
}
