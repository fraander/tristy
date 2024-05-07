//
//  NewGroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 11/2/22.
//

import SwiftUI
import SwiftData

/// Represents a list of groceries
struct GroceryListView: View {
    
    let list: GroceryList
    @Binding var listSelection: GroceryList
    @Environment(\.modelContext) var modelContext
    @Query var groceries: [Grocery]
    @State var showChangeAppIconSheet = false
    
    init(list: GroceryList, listSelection: Binding<GroceryList>) {
        self.list = list
        _listSelection = listSelection
        _groceries = Query(filter: #Predicate<Grocery> {
            return ($0.when ?? "") == list.description
        }, animation: .default)
    }
    
    var listControlGroup: some View {
        ControlGroup {
            ForEach(GroceryList.tabs, id: \.self) { tab in
                Button(tab.description, systemImage: tab.symbol) {
                    listSelection = tab
                }
            }
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
    
    var moveSection: some View {
        Group {
            ForEach(GroceryList.tabs, id: \.description) { tag in
                if (!groceries.isEmpty && list != tag) {
                    Button {
                        groceries.forEach { grocery in
                            grocery.when = tag.description
                        }
                        listSelection = tag
                    } label: {
                        Label("Move to \(tag.description)", systemImage: tag.symbol)
                    }
                }
            }
        }
    }
    
    var clearAllSection: some View {
        Group {
            let theseGroceries = groceries.filter { g in
                g.when == list.description
            }
            if (theseGroceries.count > 0) {
                Button(role: .destructive) {
                    theseGroceries.forEach { grocery in
                        modelContext.delete(grocery)
                    }
                } label: {
                    Label("Delete all", systemImage: "trash")
                }
            }
            
        }
    }
    
    var emptyListView: some View {
        GroupBox {
            VStack(spacing: 12) {
                ContentUnavailableView(
                    "Your list is clear!",
                    systemImage: list.symbol,
                    description: Text("Use the ")
                    + Text("Add Bar").bold()
                    + Text(" at the bottom of the screen to add to your list.")
                )
                .frame(height: 240)
            }
            .padding(.horizontal)
        }
        .padding(40)
    }
    
    var populatedListView: some View {
        List {
            ForEach(groceries) { grocery in
                GroceryView(grocery: grocery)
                    .listRowBackground(Color.secondaryBackground)
                    .contextMenu {
                        ControlGroup {
                            ForEach(GroceryList.tabs, id: \.self) { tab in
                                if (tab != list) {
                                    Button(tab.description, systemImage: tab.symbol) {
                                        grocery.when = tab.description
                                    }
                                }
                            }
                        }
                        Button("Remove", systemImage: "trash.fill") {
                            deleteGrocery(grocery: grocery)
                        }
                        .tint(.pink)
                    }
            }
            
            Spacer()
                .frame(height: 120)
        }
        .scrollContentBackground(.hidden)
    }
    
    var body: some View {
        Group {
            if (groceries.isEmpty) {
                emptyListView
            } else {
                populatedListView
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: list.symbol).foregroundStyle(Color.accent)
                Text(list.description)
                    .font(.system(.headline, weight: .medium))
                }
            }
        }
        .toolbarTitleMenu {
            listControlGroup
                .controlGroupStyle(.menu)
            Divider()
            toolbarCheckSection
            Divider()
            moveSection
            Divider()
            Button("Change App Icon", systemImage: "app.badge") {
                showChangeAppIconSheet = true
            }
            clearAllSection
        }
        .sheet(isPresented: $showChangeAppIconSheet) {
            VStack {
                HStack {
                    Spacer()
                    Button("Dismiss", systemImage: "checkmark") {
                        showChangeAppIconSheet = false
                    }
                }
                .padding([.top, .horizontal])
                ChangeAppIconView()
            }
        }
    }
    
    private func deleteGrocery(grocery: Grocery) {
        modelContext.delete(grocery)
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(list: .today, listSelection: .constant(.today))
    }
}
