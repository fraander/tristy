//
//  GroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI

struct GroceryListView: View {
    
    @ObservedObject var groceryListVM = GroceryListViewModel()
    
    var body: some View {
        VStack {
            Button(role: .destructive) {
                groceryListVM.groceryVMs.forEach{$0.remove()}
            } label: {
                Label("Clear All", systemImage: "eraser.line.dashed")
            }
            
            
            List {
                ForEach(groceryListVM.groceryVMs) { groceryVM in
                    GroceryView(groceryVM: groceryVM)
                }
                .onDelete(perform: deleteItems)
            }
            
            Button {
                addGrocery()
            } label: {
                Label("Add item", systemImage: "plus")
            }
        }
    }
    
    private func deleteItems(items: IndexSet) {
        items.forEach { groceryListVM.groceryVMs[$0].remove() }
    }
    
    private func addGrocery() {
        let grocery = Grocery(title: "\(groceryListVM.groceryVMs.count)")
        groceryListVM.add(grocery)
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static let listOfVM = examples.reduce([GroceryViewModel]()) { partialResult, grocery in
        let groceryVM = GroceryViewModel(grocery: grocery)
        return partialResult + [groceryVM]
    }
    
    static var previews: some View {
        GroceryListView(groceryListVM: GroceryListViewModel(listOfVM))
    }
}
