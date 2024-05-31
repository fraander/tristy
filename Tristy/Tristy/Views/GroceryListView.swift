//
//  GroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 11/2/22.
//

import SwiftUI
import SwiftData
import TipKit

struct GroceryListView: View {
    
    
    let cmTip = ContextMenuTip()
    
    let list: GroceryList
    @State var selectedGroceries: Set<Grocery> = .init()
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
        }, sort: [
            SortDescriptor(\Grocery.completed, order: .forward),
            SortDescriptor(\Grocery.priority, order: .reverse),
            SortDescriptor(\Grocery.title, order: .forward)
        ], animation: .default)
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
                grocery.priority = GroceryPriority.none.value
            }
        } label: {
            Label("Deprioritize All", systemImage: "exclamationmark.2")
        }
        
        return Group {
            if (hasOneSet) { unsetAll }
        }
    }
    
    var toolbarPinSection: some View {
        let hasOnePinned = groceries.contains { $0.pinned }
        let hasOneUnpinned = groceries.contains { !$0.pinned }
        
        let unpinAll = Button {
            groceries.forEach { grocery in
                grocery.pinned = false
            }
        } label: {
            Label("Unpin All", systemImage: "pin.slash")
        }
        
        let pinAll = Button {
            groceries.forEach { grocery in
                grocery.pinned = true
            }
        } label: {
            Label("Pin All", systemImage: "pin.fill")
        }
        
        return Group {
            if (hasOnePinned) { unpinAll }
            if (hasOneUnpinned) { pinAll }
        }
    }
    
    var moveSection: some View {
        Group {
            ForEach(GroceryList.tabs, id: \.description) { tag in
                if (!groceries.isEmpty && list != tag) {
                    Button {
                        groceries.forEach { grocery in
                            if (!grocery.pinned) {
                                grocery.when = tag.description
                            }
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
        #if os(macOS)
        .frame(maxHeight: .infinity, alignment: .top)
        #endif
    }
    
    func groceryMoveActions(grocery: Grocery) -> some View {
        Group {
            ForEach(GroceryList.tabs, id: \.self) { tab in
                if (tab != list) {
                    Button(tab.description, systemImage: tab.symbol) {
                        if (selectedGroceries.map(\.id).contains(grocery.id)) {
                            selectedGroceries.forEach { g in
                                withAnimation {
                                    g.when = tab.description
                                    g.priority = GroceryPriority.none.value
                                }
                            }
                        } else {
                            withAnimation {
                                grocery.when = tab.description
                                grocery.priority = GroceryPriority.none.value
                            }
                        }
                    }
                }
            }
        }
    }
    
    func groceryPriorityActions(grocery: Grocery) -> some View {
        ForEach(GroceryPriority.tabs, id: \.self) { tab in
            Button(tab.description, systemImage: tab.symbol) {
                if (selectedGroceries.map(\.id).contains(grocery.id)) {
                    selectedGroceries.forEach { g in
                        withAnimation {
                            g.priority = tab.value
                        }
                    }
                } else {
                    withAnimation {
                        grocery.priority = tab.value
                    }
                }
            }
        }
    }
    
    var populatedListView: some View {
        List(selection: $selectedGroceries) {
            ForEach(groceries) { grocery in
                GroceryView(grocery: grocery)
                    .tag(grocery)
#if os(iOS)
                    .popoverTip(cmTip)
                    .listRowBackground(Color.secondaryBackground)
#endif
                    .contextMenu {
#if os(iOS)
                        ControlGroup {
                            groceryMoveActions(grocery: grocery)
                        }
#else
                        groceryMoveActions(grocery: grocery)
                        Divider()
#endif
                        
#if os(iOS)
                        ControlGroup {
                            groceryPriorityActions(grocery: grocery)
                        }
#else
                        groceryPriorityActions(grocery: grocery)
                        
                        
                        Divider()
#endif
                        
                        Button(grocery.pinned ? "Unpin" : "Pin", systemImage: grocery.pinned ? "pin.slash" : "pin") {
                            grocery.pinned.toggle()
                        }
                        
                        Divider()

                        Button("Remove", systemImage: "trash.fill", role: .destructive) {
                            if (selectedGroceries.map(\.id).contains(grocery.id)) {
                                selectedGroceries.forEach { g in
                                    deleteGrocery(grocery: g)
                                }
                            } else {
                                deleteGrocery(grocery: grocery)
                            }
                        }
                        .onAppear {
                            cmTip.invalidate(reason: .actionPerformed)
                        }
                    }
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
#if os(iOS)
        .scrollContentBackground(.hidden)
#endif
    }
    
    var copyListButton: some View {
        Button("Copy List", systemImage: "doc.on.clipboard") {
            let shareContent = "Tristy: " + list.description
            + "\n" + groceries
                .map { "\($0.completed ? "[x]" : "[ ]") \($0.title)" }
                .joined(separator: "\n")
#if os(iOS)
            UIPasteboard.general.string = shareContent
#else
            NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
            NSPasteboard.general.setString(shareContent, forType: .string)
#endif
        }
    }
    
    var titleMenuContent: some View {
        Group {
#if os(iOS)
            listControlGroup
                .controlGroupStyle(.menu)
            Divider()
#endif
            toolbarCheckSection
            toolbarPrioritySection
            toolbarPinSection
            Divider()
            moveSection
            Divider()
            
            copyListButton
#if os(iOS)
            Button("Change App Icon", systemImage: "app.badge") {
                showChangeAppIconSheet = true
            }
#endif
            clearAllSection
        }
        .font(.system(.body, design: .rounded))
    }
    
    var body: some View {
        Group {
            
            if (groceries.isEmpty) {
                emptyListView
            } else {
                populatedListView
            }
        }
        #if os(iOS)
        .toolbarTitleMenu {
            titleMenuContent
        }
        #else
        .toolbar {            
            if (!groceries.isEmpty) {
                ToolbarItem(placement: .primaryAction) {
                    Menu("Actions", systemImage: "ellipsis.circle") {
                        titleMenuContent
                    }
                }                
            }
        }
        #endif
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                HStack {
                    Image(systemName: listSelection.symbol)
                        .foregroundColor(.accentColor)
                    Text(listSelection.description)
                }
                .font(.system(.headline, design: .rounded, weight: .medium))
            }
        }
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
