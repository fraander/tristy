//
//  GroceryDetailView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/16/25.
//

import AttributedTextEditor
import SwiftData
import SwiftUI

struct GroceryDetailView: View {
    @Environment(Router.self) var router
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) var editMode
    
    var originalGroceries: [Grocery]
    @State var groceries: [GroceryDraft] = []
    let isBulkMode: Bool
    
    @Query(sort: [SortDescriptor(\GroceryStore.sortOrder, order: .forward)]) var stores: [GroceryStore]
    
    enum DetailViewTypes {
        case bulk([Grocery]), single(Grocery), new
    }
    init(type: DetailViewTypes) {
        switch type {
            
        case .bulk(let g):
            _groceries = State(initialValue: g.map { GroceryDraft(from: $0) })
            self.originalGroceries = g
            self.isBulkMode = true
        case .single(let g):
            _groceries = State(initialValue: [ GroceryDraft(from: g) ]
            )
            self.originalGroceries = [g]
            self.isBulkMode = false
        case .new:
            _groceries = State(initialValue: [GroceryDraft()])
            self.originalGroceries = []
            self.isBulkMode = false
        }
    }
    
    @State var showingDeleteConfirmation = false
    @State var selection = AttributedTextSelection()
    
    var propertiesSection: some View {
        Section {
            let completedBinding = Binding<Bool> {
                groceries.first?.workingCompleted ?? false
            } set: { newValue in
                groceries.indices.forEach { idx in
                    groceries[idx].workingCompleted = newValue
                    groceries[idx].hasChangedWorkingCompleted = true
                }
            }
            let pinnedBinding = Binding<Bool> {
                groceries.first?.workingPinned ?? false
            } set: { newValue in
                groceries.indices.forEach { idx in
                    groceries[idx].workingPinned = newValue
                    groceries[idx].hasChangedWorkingPinned = true
                }
            }
            let uncertainBinding = Binding<Bool> {
                groceries.first?.workingUncertain ?? false
            } set: { newValue in
                groceries.indices.forEach { idx in
                    groceries[idx].workingUncertain = newValue
                    groceries[idx].hasChangedWorkingUncertain = true
                }
            }
            let importanceBinding = Binding<GroceryImportance> {
                groceries.first?.workingImportance ?? .none
            } set: { newValue in
                groceries.indices.forEach { idx in
                    groceries[idx].workingImportance = newValue
                    groceries[idx].hasChangedWorkingImportance = true
                }
            }
            let quantityBinding = Binding<Double> {
                groceries.first?.workingQuantity ?? 0
            } set: { newValue in
                groceries.indices.forEach { idx in
                    groceries[idx].workingQuantity = newValue
                    groceries[idx].hasChangedWorkingQuantity = true
                }
            }
            let unitsBinding = Binding<String> {
                groceries.first?.workingUnits ?? ""
            } set: { newValue in
                groceries.indices.forEach { idx in
                    groceries[idx].workingUnits = newValue.lowercased()
                    groceries[idx].hasChangedWorkingUnits = true
                }
            }
            
            Toggle(
                "Completed",
                systemImage: Symbols.complete,
                isOn: completedBinding
            )
            .labelStyle(.tintedIcon(icon: .mint))
            .symbolToggleEffect(
                completedBinding.wrappedValue,
                activeVariant: .circle.fill,
                inactiveVariant: .circle
            )
            
            Toggle("Pinned", systemImage: Symbols.pinned, isOn: pinnedBinding)
                .labelStyle(.tintedIcon(icon: .orange))
                .symbolToggleEffect(pinnedBinding.wrappedValue)
            
            Toggle(
                "Uncertain",
                systemImage: Symbols.uncertain,
                isOn: uncertainBinding
            )
            .labelStyle(.tintedIcon(icon: .indigo))
            .symbolToggleEffect(uncertainBinding.wrappedValue)
            
            Picker(selection: importanceBinding) {
                ForEach(GroceryImportance.allCases) { importance in
                    Label(importance.name, systemImage: importance.symbolName)
                        .tag(importance)
                }
            } label: {
                Label("Importance", systemImage: importanceBinding.wrappedValue.symbolName)
                    .contentTransition(.symbolEffect)
                    .labelStyle(.tintedIcon(icon: importanceBinding.wrappedValue.color))
            }
            .tint(.secondary)
            
            LabeledContent {
                HStack {
                    TextField("2", text: Binding<String>(
                        get: { quantityBinding.wrappedValue == .zero ? "" : formatDouble(quantityBinding.wrappedValue) },
                        set: { if let new = Double($0) { quantityBinding.wrappedValue = new } }
                    ))
                    .numbersOnly(Binding<String>(
                        get: { quantityBinding.wrappedValue == .zero ? "" : formatDouble(quantityBinding.wrappedValue) },
                        set: { if let new = Double($0) { quantityBinding.wrappedValue = new } }
                    ), includeDecimal: true)

                    TextField("cups", text: Binding<String>(
                        get: { unitsBinding.wrappedValue.lowercased() },
                        set: { unitsBinding.wrappedValue = $0 }
                    ))
                    .autocorrectionDisabled()
                }
                .frame(maxWidth: 100)
            } label: {
                Label("Quantity", systemImage: Symbols.quantity)
                    .labelStyle(
                        .tintedIcon(
                            icon: Color.primary.mix(
                                with: Color.secondary,
                                by: 0.75
                            )
                        )
                    )
            }
        } header: {
            HStack {
                Text("Properties")
                
                Spacer()
                
                if hasSetProperties {
                    Button(
                        "Reset",
                        systemImage: Symbols.reset,
                        action: resetProperties
                    )
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
                    .transition(.scale)
                }
            }
            .frame(height: 24)
            .animation(.easeInOut, value: hasSetProperties)
        }
        .transition(.move(edge: .top))
    }
    
    @State var animationAngle: CGFloat = 0.0
    
    var grocerySection: some View {
        Group {
            
            let titleBinding = Binding<String> {
                groceries.first?.workingTitle ?? ""
            } set: { newValue in
                groceries.enumerated().forEach { index, _ in
                    groceries[index].workingTitle = newValue
                    groceries[index].hasChangedWorkingTitle = true
                }
            }

            if !isBulkMode {
                TextField("Title", text: titleBinding)
            }
            
            
            let categoryBinding = Binding<GroceryCategory> {
                groceries.first?.workingCategory ?? .other
            } set: { newValue in
                groceries.enumerated().forEach { index, _ in
                    groceries[index].workingCategory = newValue
                    groceries[index].hasChangedWorkingCategory = true
                }
            }
            
            Picker(selection: categoryBinding) {
                ForEach(GroceryCategory.allCases) { category in
                    if category == .other {
                        Divider()
                    }
                    Label(
                        category.rawValue,
                        systemImage: category.symbolName
                    )
                    .tint(category.color)
                    .symbolVariant(.fill)
                    .tag(category)
                }
            } label: {
                Label {
                    Text("Category")
                } icon: {
                    Image(systemName: categoryBinding.wrappedValue.symbolName)
                        .contentTransition(.symbolEffect)
                }
                .animation(
                    .linear(duration: 1.5).repeatForever(autoreverses: false),
                    value: animationAngle
                )
                .labelStyle(.tintedIcon(icon: categoryBinding.wrappedValue.color))
            }
            .tint(.secondary)
            
            let storeBinding = Binding<GroceryStore?> {
                groceries.first?.workingStore ?? nil
            } set: { newValue in
                groceries.enumerated().forEach { index, _ in
                    groceries[index].workingStore = newValue
                    groceries[index].hasChangedWorkingStore = true
                }
            }
            
            Picker(selection: storeBinding) {
                Label("None", systemImage: Symbols.none)
                    .tint(.secondary)
                    .tag(nil as GroceryStore?)
                
                Divider()
                
                ForEach(stores) { store in
                    Label(store.nameOrEmpty, systemImage: store.symbolOrDefault)
                        .tint(store.colorOrDefault)
                        .tag(store as GroceryStore?)
                }
            } label: {
                Label(
                    "Store",
                    systemImage: storeBinding.wrappedValue?.symbolOrDefault ?? Symbols.none
                )
                .contentTransition(.symbolEffect)
                .labelStyle(
                    .tintedIcon(
                        icon: storeBinding.wrappedValue?.colorOrDefault ?? .secondary
                    )
                )
            }
            .tint(.secondary)
            
            let listBinding = Binding<GroceryList> {
                groceries.first?.workingList ?? .active
            } set: { newValue in
                groceries.enumerated().forEach { index, _ in
                    groceries[index].workingList = newValue
                    groceries[index].hasChangedWorkingList = true
                }
            }
            
            Picker(selection: listBinding) {
                ForEach(GroceryList.allCases) { list in
                    Label(list.name, systemImage: list.symbolName)
                        .tint(list.color)
                        .tag(list)
                }
            } label: {
                Label("List", systemImage: listBinding.wrappedValue.symbolName)
                    .contentTransition(.symbolEffect)
                    .labelStyle(.tintedIcon(icon: listBinding.wrappedValue.color))
            }
            .tint(.secondary)
        }
    }
    
    var placeholderText: String {
#if os(iOS)
        "You can use Markdown here. ..."
#else
        ""
#endif
    }
    
    var contents: some View {
        Group {
            Section("Grocery") {
                grocerySection
            }
            
            if (groceries.first?.workingList ?? .active) == .active {
                propertiesSection
            }
            
            Section {
                let notesBinding = Binding<AttributedString> {
                    groceries.first?.workingNotes ?? ""
                } set: { newValue in
                    groceries.indices.forEach { idx in
                        groceries[idx].workingNotes = newValue
                        groceries[idx].hasChangedWorkingNotes = true
                    }
                }
                ComposerTextEditorView(
                    text: notesBinding,
                    selection: $selection,
                    placeholder: placeholderText
                )
                .frame(minHeight: 160)
#if os(macOS)
                .padding(5)
                .background {
                    Color.systemGroupedBackground
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(.gray, lineWidth: 0.5)
                        .fill(.clear)
                }
#endif
            } header: {
                HStack {
                    Text("Notes")
                    Spacer()
                    
                    if hasSetNotes {
                        Button("Reset", systemImage: Symbols.reset) {
                            groceries.indices.forEach { idx in
                                groceries[idx].workingNotes = ""
                                groceries[idx].hasChangedWorkingNotes = true
                            }
                        }
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.secondary)
                        .transition(.scale)
                    }
                }
                .frame(height: 24)
                .animation(.easeInOut, value: hasSetNotes)
            }
            
            Button(role: .destructive) { showingDeleteConfirmation = true }
                .labelStyle(.tintedIcon(icon: .red, text: .primary))
                .confirmationDialog(
                    "Are you sure you would like to delete?",
                    isPresented: $showingDeleteConfirmation,
                    titleVisibility: .visible,
                ) {
                    Button("Yes, delete", role: .destructive, action: delete)
                } message: {
                    Text("This cannot be reverted.")
                }
        }
    }
    
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) { dismiss() }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    saveChanges()
                }
                .disabled((groceries.first?.workingTitle.isEmpty ?? true))
            }
            
            ToolbarItem(placement: .principal) {
                Text(isBulkMode ? "Edit (Bulk)" : (originalGroceries.isEmpty ? "Create" : "Edit"))
            }
        }
    }
    
    var body: some View {
#if os(iOS)
        NavigationView {
            Form {
                contents
            }
            .toolbar { toolbar }
            .animation(.easeInOut, value: (groceries.first?.workingList ?? .active) == .active)
        }
#elseif os(macOS)
        ScrollView {
            VStack(alignment: .leading) { contents }
                .padding()
                .padding()
        }
        .background { BackgroundView() }
        .toolbar { toolbar }
        .animation(.easeInOut, value: (groceries.first?.workingList ?? .active) == .active)
#endif
    }
    
    var hasSetNotes: Bool { !(groceries.first?.workingNotes.characters.isEmpty ?? true) }
    
    var hasSetProperties: Bool {
        guard let g = groceries.first else { return false }
        return !(g.workingCompleted == false && g.workingUncertain == false
          && g.workingImportance == .none && g.workingPinned == false
          && g.workingQuantity == 0 && g.workingUnits.isEmpty)
    }
    
    func resetProperties() {
        groceries.indices.forEach { idx in
            // Properties
            groceries[idx].workingCompleted = false
            groceries[idx].hasChangedWorkingCompleted = true
            groceries[idx].workingUncertain = false
            groceries[idx].hasChangedWorkingUncertain = true
            groceries[idx].workingImportance = .none
            groceries[idx].hasChangedWorkingImportance = true
            groceries[idx].workingPinned = false
            groceries[idx].hasChangedWorkingPinned = true
            groceries[idx].workingQuantity = 0
            groceries[idx].hasChangedWorkingQuantity = true
            groceries[idx].workingUnits = ""
            groceries[idx].hasChangedWorkingUnits = true
            
            // Core fields
            groceries[idx].workingTitle = ""
            groceries[idx].hasChangedWorkingTitle = true
            groceries[idx].workingList = .active
            groceries[idx].hasChangedWorkingList = true
            groceries[idx].workingStore = nil
            groceries[idx].hasChangedWorkingStore = true
            groceries[idx].workingCategory = .other
            groceries[idx].hasChangedWorkingCategory = true
        }
    }
    
    func resetNotes() {
        groceries.indices.forEach { idx in
            groceries[idx].workingNotes = ""
            groceries[idx].hasChangedWorkingNotes = true
        }
    }
    
    func formatDouble(_ value: Double) -> String {
        let str = String(value)
        return str.hasSuffix(".0") ? String(str.dropLast(2)) : str
    }
    
    func delete() {
        if isBulkMode {
            originalGroceries.forEach { modelContext.delete($0) }
        } else if let g = originalGroceries.first {
            modelContext.delete(g)
        }
        let _ = try? modelContext.save()
        dismiss()
    }
    
    func saveChanges() {
        if originalGroceries.isEmpty {
            // create new from first draft
            if let d = groceries.first {
                let g = Grocery(
                    list: d.workingList,
                    title: d.workingTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
                    completed: d.workingCompleted,
                    notes: String(d.workingNotes.characters),
                    certainty: d.workingUncertain,
                    importance: d.workingImportance,
                    pinned: d.workingPinned,
                    quantity: d.workingQuantity,
                    unit: d.workingUnits,
                    category: d.workingCategory,
                    store: d.workingStore
                )
                modelContext.insert(g)
            }
        } else {
            // update existing (bulk or single) from first draft's shared fields
            if let d = groceries.first {
                originalGroceries.forEach { g in
                    if d.hasChangedWorkingTitle {
                        g.title = d.workingTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    
                    if d.hasChangedWorkingList {
                        g.setList(d.workingList)
                    }
                    
                    if d.hasChangedWorkingStore {
                        g.store = d.workingStore
                    }
                    
                    // apply only fields that changed in the draft
                    if d.hasChangedWorkingCompleted {
                        g.setCompleted(to: d.workingCompleted)
                    }
                    if d.hasChangedWorkingPinned {
                        g.setPinned(to: d.workingPinned)
                    }
                    if d.hasChangedWorkingUncertain {
                        g.setCertainty(to: d.workingUncertain)
                    }
                    if d.hasChangedWorkingImportance {
                        g.setImportance(d.workingImportance)
                    }
                    if d.hasChangedWorkingQuantity {
                        g.quantity = d.workingQuantity
                    }
                    if d.hasChangedWorkingUnits {
                        g.unit = d.workingUnits
                    }
                    if d.hasChangedWorkingNotes {
                        g.notes = String(d.workingNotes.characters)
                    }
                    if d.hasChangedWorkingCategory {
                        g.setCategory(to: d.workingCategory)
                    }
                }
            }
        }
        let _ = try? modelContext.save()
        router.selectedGroceries.removeAll()
        dismiss()
    }
}

#Preview(traits: .sampleData) {
    BackgroundView()
        .sheet(isPresented: .constant(true)) {
            GroceryDetailView(
                type: .single(
                    Grocery(
                        list: .active,
                        title: "Crackers",
                        completed: true,
                        category: nil
                    )
                )
            )
        }
}

