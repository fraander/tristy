//
//  StoreActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/29/25.
//

import SwiftUI
import SwiftData
import SymbolPicker

struct StoreBrowser: View {
    @Environment(\.modelContext) var modelContext
    @Query var stores: [GroceryStore]
    
    var body: some View {
        if stores.isEmpty {
            ContentUnavailableView("No stores. Add one to get started.", systemImage: Symbols.emptyList)
        } else {
            ForEach(stores) { store in
                Label(store.nameOrEmpty, systemImage: store.symbolOrDefault)
                    .labelStyle(.tintedIcon(store.colorOrDefault))
                    .labelIconToTitleSpacing(18)
            }
            .onDelete(perform: deleteStore)
        }
    }
    
    func deleteStore(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(stores[index])
        }
    }
}

struct StoreAdder: View {
    @Environment(\.modelContext) var modelContext
    
    @State var newTitle = ""
    @State var newSymbol = Symbols.basket
    @State var newColor: SymbolColor = .moro
    
    @State var showingSymbolPicker = false
    
    var body: some View {
        
        Label {
            TextField("New store ...", text: $newTitle)
                .submitLabel(.done)
                .onSubmit {
                    if newTitle.isEmpty { return }
                    
                    // insert
                    let newStore = GroceryStore(
                        name: newTitle,
                        symbolName: newSymbol,
                        color: newColor.color
                    )
                    modelContext.insert(newStore)
                    
                    // reset
                    newTitle = ""
                    newSymbol = Symbols.basket
                    newColor = .moro
                }
        } icon: {
            Button("Icon", systemImage: newSymbol) {
                showingSymbolPicker.toggle()
            }
            .foregroundStyle(newColor.color)
            .labelStyle(.iconOnly)
        }
        .labelIconToTitleSpacing(18)
        .symbolPicker(
            isPresented: $showingSymbolPicker,
            symbolName: $newSymbol,
            color: $newColor
        )
    }
}

struct StoreActions: View {
    
    
    var body: some View {
        Group {
            StoreBrowser()
            StoreAdder()
        }
    }
    
    
}

#Preview {
    List {
        StoreActions()
    }
        .applyEnvironment(prePopulate: true)
}
