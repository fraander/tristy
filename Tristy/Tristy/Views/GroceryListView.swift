//
//  GroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI

struct GroceryListView: View {
    
    enum Focus {
        case addField, none
    }
    
    @Environment(\.colorScheme) var colorMode
    @ObservedObject var groceryListVM = GroceryListViewModel()
    @State var text = ""
    @FocusState var focusState: Focus?
    
    var clearAllButton: some View {
        Button(role: .destructive) {
            groceryListVM.groceryVMs.forEach{$0.remove()}
        } label: {
            Label("Clear All", systemImage: "eraser.line.dashed")
        }
    }
    
    var listOfGrocery: some View {
        List {
            ForEach(groceryListVM.groceryVMs) { groceryVM in
                NavigationLink {
                    GroceryDetailView(groceryVM: GroceryDetailViewModel(grocery: groceryVM.grocery))
                } label: {
                    GroceryView(groceryVM: groceryVM)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        groceryVM.grocery.completed.toggle()
                        groceryVM.update(grocery: groceryVM.grocery)
                    } label: {
                        Label("\(groceryVM.grocery.completed ? "Uncheck" : "Check off")",
                              systemImage: "\(groceryVM.grocery.completed ? "xmark" : "checkmark")")
                    }
                    .tint(Color.mint)
                }

            }
            .onDelete(perform: deleteItems)
        }
    }
    
    var addGroceryButton: some View {
        HStack {
            Button {
                addGrocery(title: text)
            } label: {
                Image(systemName: "plus")
            }
            .tint(focusState == .addField ? Color.accentColor : Color.secondary)
            
            TextField("Add item...", text: $text)
                .focused($focusState, equals: .addField)
                .onSubmit {
                    addGrocery(title: text)
                }
                .submitLabel(.done)
            
            // add ways to change attributes of the text
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10.0)
                .strokeBorder(Color.secondary, lineWidth: 1)
                .background {
                    RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemBackground))
                }
                .shadow(
                    color: focusState == .addField ? Color.accentColor : Color.clear,
                    radius: focusState == .addField ? 3 : 0
                )
                .animation(Animation.easeInOut(duration: 0.25), value: focusState)
        }
        .padding()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                listOfGrocery
                
                addGroceryButton
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Groceries")
            .toolbarTitleMenu {
                clearAllButton
            }
        }
    }
    
    private func deleteItems(items: IndexSet) {
        items.forEach { groceryListVM.groceryVMs[$0].remove() }
    }
    
    private func addGrocery(title: String) {
        if (!text.isEmpty) {
            let grocery = Grocery(title: title)
            groceryListVM.add(grocery)
            text = ""
            focusState = GroceryListView.Focus.none
        }
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static let listOfVM = examples.reduce([GroceryViewModel]()) { partialResult, grocery in
        let groceryVM = GroceryViewModel(grocery: grocery)
        return partialResult + [groceryVM]
    }
    
    static var previews: some View {
        GroceryListView(groceryListVM: GroceryListViewModel(listOfVM))
            .previewDisplayName("Populated list")
        
        GroceryListView(groceryListVM: GroceryListViewModel([]))
            .previewDisplayName("Empty list")
    }
}
