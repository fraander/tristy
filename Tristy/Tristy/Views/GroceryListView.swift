//
//  NewGroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 11/2/22.
//

import SwiftUI
import SwiftData

enum Focus {
    case addField, none
}

/// Represents a list of groceries
struct GroceryListView: View {

    @Environment(\.modelContext) var modelContext
    @Query var groceries: [Grocery]
    
    
    // MARK: - List of Groceries
    var listOfGroceries: some View {
        Group {
            if (groceries.isEmpty) {
                emptyListView
            } else {
                populatedListView
            }
        }
    }
    
    var emptyListView: some View {
        GroupBox {
            VStack(spacing: 12) {
                Text("Your list is clear!")
                    .font(.system(.headline, design: .rounded))
                
                Group {
                    Text("Use the ")
                    + Text("Add Bar").bold()
                    + Text(" at the bottom of the screen to add to your list.")
                }
                .font(.system(.caption, design: .rounded))
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .padding(40)
    }
    
    var populatedListView: some View {
        List {
            ForEach(groceries) { grocery in
                GroceryView(grocery: grocery)
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    // MARK: - Toolbar Menu
    var toolbarMenu: some View {
        Group {
            toolbarCheckSection
            Divider()
            clearAllSection
        }
    }
    
    var toolbarCheckSection: some View {
        let hasOneComplete = groceries.contains { $0.completed == true }
        let hasOneIncomplete = groceries.contains { $0.completed == false }
        
        let uncheckAll = Button {
            groceries.forEach { grocery in
                grocery.completed = false
            }
        } label: {
            Label("Uncheck All", systemImage: "xmark")
        }
        
        let checkAll = Button {
            groceries.forEach { grocery in
                grocery.completed = true
            }
        } label: {
            Label("Complete All", systemImage: "checkmark")
        }
        
        return Group {
            if (hasOneComplete) { uncheckAll }
            if (hasOneIncomplete) { checkAll }
        }
    }
    
    var clearAllSection: some View {
        Group {
            if (!groceries.isEmpty) {
                Button(role: .destructive) {
                    groceries.forEach { grocery in
                        modelContext.delete(grocery)
                    }
                } label: {
                    Label("Clear All", systemImage: "eraser.line.dashed")
                }
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                listOfGroceries
                AddBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Groceries")
#if os(macOS)
            .navigationSubtitle(GroupService.shared.groupId)
#endif
            .toolbarTitleMenu {
                toolbarMenu
            }
        }
    }
    
    private func deleteItems(items: IndexSet) {
        items.forEach {
            modelContext.delete(groceries[$0])
        }
    }

}

struct NewGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
    }
}
