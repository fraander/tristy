//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct ShoppingListView: View {
    
    var contents: some View {
        List(0..<100, id: \.self) { i in
            Text("Route \(i)")
        }
        .scrollContentBackground(.hidden)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .accent)
                
                contents
            }
            .navigationTitle("My Shopping List")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Filter", systemImage: Symbols.filter) {}
                    Button("Show only completed", systemImage: "checkmark.circle.fill") {}
                    Menu("More", systemImage: Symbols.more) {
                        Button("More 1") {}
                        Button("More 2") {}
                        Button("More 3") {}
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") {}
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .shoppingList))
        .applyEnvironment()
}
