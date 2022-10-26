//
//  GroceryDetailView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/11/22.
//

import SwiftUI

struct GroceryDetailView: View {
    
    @ObservedObject var groceryVM: GroceryDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Title", text: $groceryVM.grocery.title)
                .onSubmit {
                    groceryVM.update()
                }
        }
        .navigationTitle(groceryVM.grocery.title)
        .onDisappear {
            groceryVM.update()
        }
        #if os(iOS)
        .toolbarTitleMenu {
            Button {
                groceryVM.remove()
                dismiss()
            } label: {
                Label("Delete Item", systemImage: "trash")
            }

        }
        #elseif os(macOS)
        .toolbar {
            Button {
                groceryVM.remove()
                dismiss()
            } label: {
                Label("Delete Item", systemImage: "trash")
            }

        }
        #endif
    }
}

struct GroceryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryDetailView(groceryVM: GroceryDetailViewModel(grocery: examples[0]))
    }
}
