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
    
    @State var setQtyAlertValue: Grocery? = nil
    @State var showSetQtyAlert: Bool = false
    @State private var numberString = ""
    
    init(list: GroceryList, listSelection: Binding<GroceryList>) {
        self.list = list
        _listSelection = listSelection
        _groceries = Query(filter: #Predicate<Grocery> {
            return ($0.when ?? "") == list.description
        }, sort: [
            SortDescriptor(\Grocery.completed, order: .forward),
            SortDescriptor(\Grocery.priority, order: .reverse),
            SortDescriptor(\Grocery.title, order: .forward)
        ], animation: .smooth)
    }
    
    var listControlGroup: some View {
        ControlGroup {
            ForEach(GroceryList.allCases) { tab in
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
            if (hasOneIncomplete) { checkAll }
            if (hasOneComplete) { uncheckAll }
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
            if (hasOneUnpinned) { pinAll }
            if (hasOnePinned) { unpinAll }
        }
    }
    
    var setQtyAlertContents: some View {
        VStack {
            Text("Set Quatity")
                .font(.system(.headline, design: .rounded, weight: .semibold))
            
            TextField("Quantity", text: $numberString)
                .textFieldStyle(.roundedBorder)
            #if os(iOS)
                .keyboardType(.decimalPad)
            #endif
                .numbersOnly($numberString, includeDecimal: true)
                .onSubmit {
                    if let value = Double(numberString) {
                        setQtyAlertValue?.quantity = value
                    }
                    showSetQtyAlert = false
                    setQtyAlertValue = nil
                }
                .onChange(of: setQtyAlertValue) { old, new in
                    if let value = new?.quantity {
                        if value > 0 {
                            if Double(Int(value)) == value {
                                numberString = String(Int(value))
                            } else {
                                numberString = String(value)
                            }
                        } else {
                            numberString = ""
                        }
                    }
                }
            
            HStack {
                Button("Cancel", role: .cancel) {
                    showSetQtyAlert = false
                    setQtyAlertValue = nil
                }
                .buttonStyle(.bordered)
                
                Button("Set") {
                    if let value = Double(numberString) {
                        setQtyAlertValue?.quantity = value
                    }
                    showSetQtyAlert = false
                    setQtyAlertValue = nil
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(minWidth: 240, maxWidth: 300)
        .padding()
    }
    
    var moveSection: some View {
        Group {
            if (list.description == GroceryList.today.description) {
                ForEach(GroceryList.allCases) { tag in
                    if (!groceries.isEmpty && list.description != tag.description) {
                        Button {
                            groceries.forEach { grocery in
                                if (!grocery.pinned) {
                                    grocery.when = tag.description
                                    grocery.completed = false
                                    grocery.priority = GroceryPriority.none.value
                                    grocery.quantity = 0
                                }
                            }
                        } label: {
                            Label("Move unpinned to \(tag.description)", systemImage: tag.symbol)
                        }
                    }
                }
                
                Divider()
                
                ForEach(GroceryList.allCases) { tag in
                    if (!groceries.isEmpty && list != tag) {
                        Button {
                            groceries.forEach { grocery in
                                if (!grocery.pinned && grocery.completed) {
                                    grocery.when = tag.description
                                    grocery.completed = false
                                    grocery.quantity = 0
                                    grocery.priority = GroceryPriority.none.value
                                }
                            }
                            //                        listSelection = tag
                        } label: {
                            Label("Move completed to \(tag.description)", systemImage: tag.symbol)
                        }
                    }
                }
            } else if (list.description != GroceryList.today.description) {
                ForEach(GroceryList.allCases) { tag in
                    if (!groceries.isEmpty && list != tag) {
                        Button {
                            groceries.forEach { grocery in
                                grocery.when = tag.description
                                grocery.completed = false
                                grocery.quantity = 0
                                grocery.priority = GroceryPriority.none.value
                            }
                        } label: {
                            Label("Move to \(tag.description)", systemImage: tag.symbol)
                        }
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
            ForEach(GroceryList.allCases) { tab in
                if (tab != list) {
                    Button(tab.description, systemImage: tab.symbol) {
                        if (selectedGroceries.map(\.id).contains(grocery.id)) {
                            selectedGroceries.forEach { g in
                                withAnimation {
                                    g.when = tab.description
                                    g.priority = GroceryPriority.none.value
                                    g.pinned = false
                                    g.completed = false
                                }
                            }
                        } else {
                            withAnimation {
                                grocery.when = tab.description
                                grocery.priority = GroceryPriority.none.value
                                grocery.pinned = false
                                grocery.completed = false
                                grocery.quantity = 0
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
                
                GroceryView(grocery: grocery, list: list, setQtyAlertValue: $setQtyAlertValue, showSetQtyAlert: $showSetQtyAlert)
                    .tag(grocery)
#if os(iOS)
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
                        if (grocery.when == GroceryList.today.description) {
                            ControlGroup {
                                groceryPriorityActions(grocery: grocery)
                            }
                        }
#else
                        if (grocery.when == GroceryList.today.description) {
                            groceryPriorityActions(grocery: grocery)
                            
                            
                            Divider()
                        }
#endif
                        if (grocery.when == GroceryList.today.description) {
                            
                            if grocery.quantity > 0 {
                                Button("Remove quantity", systemImage: "delete.left") {
                                    grocery.quantity = 0
                                }
                            }
                            Button("Set quantity", systemImage: "numbers") {
                                setQtyAlertValue = grocery
                                showSetQtyAlert = true
                            }
                            
                            Divider()
                            
                            if (!grocery.pinned || (selectedGroceries.map(\.id).contains(grocery.id) && selectedGroceries.map(\.pinned).contains(false))) {
                                Button("Pin", systemImage: "pin.fill") {
                                    if (selectedGroceries.map(\.id).contains(grocery.id)) {
                                        selectedGroceries.forEach { g in
                                            g.pinned = true
                                        }
                                    } else {
                                        grocery.pinned = true
                                    }
                                }
                            }
                            
                            if (grocery.pinned || (selectedGroceries.map(\.id).contains(grocery.id) && selectedGroceries.map(\.pinned).contains(true))) {
                                Button("Unpin", systemImage: "pin.slash") {
                                    if (selectedGroceries.map(\.id).contains(grocery.id)) {
                                        selectedGroceries.forEach { g in
                                            g.pinned = false
                                        }
                                    } else {
                                        grocery.pinned = false
                                    }
                                }
                            }
                            
                            Divider()
                        }

                        Button("Remove", systemImage: "trash.fill", role: .destructive) {
                            if (selectedGroceries.map(\.id).contains(grocery.id)) {
                                selectedGroceries.forEach { g in
                                    deleteGrocery(grocery: g)
                                }
                            } else {
                                deleteGrocery(grocery: grocery)
                            }
                        }
                    }
                    .onAppear {
                        cmTip.invalidate(reason: .actionPerformed)
                    }
            }
        }
        .popoverTip(cmTip)
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
//#if os(iOS)
//            Button("Change App Icon", systemImage: "app.badge") {
//                showChangeAppIconSheet = true
//            }
//#endif
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
        #if os(macOS)
        .sheet(isPresented: $showSetQtyAlert) {
            setQtyAlertContents
        }
        #else
        .alert("Set Quantity", isPresented: $showSetQtyAlert) {
            Group {
                TextField("Quantity", text: $numberString)
                #if os(iOS)
                    .keyboardType(.decimalPad)
                #endif
                    .numbersOnly($numberString, includeDecimal: true)
                    .onAppear {
                        if let value = setQtyAlertValue?.quantity {
                            if value > 0 {
                                if Double(Int(value)) == value {
                                    numberString = String(Int(value))
                                } else {
                                    numberString = String(value)
                                }
                            } else {
                                numberString = ""
                            }
                        }
                    }
                    .onSubmit(of: .text, qtySubmitAction)
                    .onChange(of: setQtyAlertValue) { old, new in
                        if let value = new?.quantity {
                            if value > 0 {
                                if Double(Int(value)) == value {
                                    numberString = String(Int(value))
                                } else {
                                    numberString = String(value)
                                }
                            } else {
                                numberString = ""
                            }
                        }
                    }
                
                HStack {
                    Button("Cancel", role: .cancel) {
                        showSetQtyAlert = false
                        setQtyAlertValue = nil
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Set", action: qtySubmitAction)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        #endif
        
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
    
    private func qtySubmitAction() {
        if let value = Double(numberString) {
            setQtyAlertValue?.quantity = value
        } else if numberString == "" {
            setQtyAlertValue?.quantity = 0
        }
        
        showSetQtyAlert = false
        setQtyAlertValue = nil
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
