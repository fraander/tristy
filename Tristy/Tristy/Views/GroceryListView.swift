//
//  NewGroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 11/2/22.
//

import SwiftUI
import SwiftData
import TipKit

/// Represents a list of groceries
struct GroceryListView: View {
    
    
    let cmTip = ContextMenuTip()
    
    let list: GroceryList
    @Binding var listSelection: GroceryList
    @Environment(\.modelContext) var modelContext
    @Query var groceries: [Grocery]
    @State var showChangeAppIconSheet = false
    @State var alert: String? = nil
    
    init(list: GroceryList, listSelection: Binding<GroceryList>) {
        self.list = list
        _listSelection = listSelection
        _groceries = Query(filter: #Predicate<Grocery> {
            return ($0.when ?? "") == list.description
        }, sort: [SortDescriptor(\.priority, order: .reverse)], animation: .default)
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
    
    var toolbarPrioritySection: some View {
        let hasOneSet = groceries.contains { $0.priority > 0 }
        
        let unsetAll = Button {
            groceries.forEach { grocery in
                grocery.priority = GroceryPriority.toValue(GroceryPriority.none)
            }
        } label: {
            Label("Deprioritize All", systemImage: "exclamationmark.2")
        }
        
        return Group {
            if (hasOneSet) { unsetAll }
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
                    .popoverTip(cmTip)
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
                        
                        ControlGroup {
                            ForEach(GroceryPriority.tabs, id: \.self) { tab in
                                Button(tab.description, systemImage: tab.symbol) {
                                    withAnimation {
                                        grocery.priority = GroceryPriority.toValue(tab)
                                    }
                                }
                            }
                        }
                        
                        Button("Remove", systemImage: "trash.fill", role: .destructive) {
                            deleteGrocery(grocery: grocery)
                        }
                        .onAppear {
                            cmTip.invalidate(reason: .actionPerformed)
                        }
                    }
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
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
                        .font(.system(.headline, design: .rounded, weight: .medium))
                }
            }
        }
        .toolbarTitleMenu {
            Group {
            listControlGroup
                .controlGroupStyle(.menu)
            Divider()
            toolbarCheckSection
            toolbarPrioritySection
            Divider()
            moveSection
            Divider()
            
            Button("Copy List", systemImage: "doc.on.clipboard") {
                let shareContent = "Tristy: " + list.description
                + "\n" + groceries
                    .map { "\($0.completed ? "[x]" : "[ ]") \($0.title)" }
                    .joined(separator: "\n")
                #if os(iOS)
                UIPasteboard.general.string = shareContent
                #else
                NSPasteboard.general.setString(shareContent, forType: .string)
                #endif
            }
            #if os(iOS)
            Button("Change App Icon", systemImage: "app.badge") {
                showChangeAppIconSheet = true
            }
            #endif
            clearAllSection
            }
            .font(.system(.body, design: .rounded))
        }
        #if os(iOS)
        .sheet(isPresented: $showChangeAppIconSheet) {
            VStack {
                HStack {
                    Spacer()
                    Button("Done", systemImage: "checkmark") {
                        showChangeAppIconSheet = false
                    }
                    .font(.system(.body, design: .rounded))
                }
                .padding([.top, .horizontal])
                HStack {
                    Text("Change App Icon")
                        .font(.system(.headline, design: .rounded, weight: .medium))
                }
                .padding(.vertical)
                ChangeAppIconView()
            }
        }
        #endif
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
