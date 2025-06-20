//
//  GroceryDetailView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/16/25.
//

import SwiftUI
import AttributedTextEditor

#warning("add @model for grocerystore; let user set symbol, color, name. then pick from existing options. add under category in detail view.")

struct GroceryDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var modelContext
    var grocery: Grocery?
    
    init(grocery: Grocery? = nil) {
        
        self.grocery = grocery
        
        // If given a grocery to populate with, use it ...
        if let grocery {
            _workingTitle = .init(initialValue: grocery.titleOrEmpty)
            _workingList = .init(initialValue: grocery.listEnum)
            _workingCompleted = .init(initialValue: grocery.isCompleted)
            _workingPinned = .init(initialValue: grocery.isPinned)
            _workingUncertain = .init(initialValue: grocery.isUncertain)
            _workingImportance = .init(initialValue: grocery.importanceEnum)
            _workingQuantity = .init(initialValue: grocery.quantityOrEmpty)
            _workingUnits = .init(initialValue: grocery.unitOrEmpty)
            _workingNotes = .init(initialValue: AttributedString(grocery.notesOrEmpty))
            _workingCategory = .init(initialValue: grocery.categoryEnum)
            
            if (grocery.category ?? "").isEmpty {
                self.hasSetCategory = .unset
            } else { self.hasSetCategory = .set }
        }
    }
    
    @State var workingTitle: String = ""
    @State var workingList: GroceryList = .active
    @State var workingCompleted: Bool = false
    @State var workingPinned: Bool = false
    @State var workingUncertain: Bool = false
    @State var workingImportance: GroceryImportance = .none
    @State var workingQuantity: Double = .zero
    @State var workingUnits: String = ""
    @State var workingNotes: AttributedString = ""
    @State var workingCategory: GroceryCategory = .other
    
    @State var showingDeleteConfirmation = false
    @State var selection = AttributedTextSelection()
    
    @State var hasSetCategory: SetCategoryStatus = .unset
    
    enum SetCategoryStatus {
        case unset, generating, set
    }
    
    var propertiesSection: some View {
        Section {
            Toggle("Completed", systemImage: Symbols.complete, isOn: $workingCompleted)
                .labelStyle(.tintedIcon(icon: .mint))
                .symbolToggleEffect(workingCompleted, activeVariant: .circle.fill, inactiveVariant: .circle)
            
            Toggle("Pinned", systemImage: Symbols.pinned, isOn: $workingPinned)
                .labelStyle(.tintedIcon(icon: .orange))
                .symbolToggleEffect(workingPinned)
            
            Toggle("Uncertain", systemImage: Symbols.uncertain, isOn: $workingUncertain)
                .labelStyle(.tintedIcon(icon: .indigo))
                .symbolToggleEffect(workingUncertain)
            
            Picker(selection: $workingImportance) {
                ForEach(GroceryImportance.allCases) { importance in
                    Label(importance.name, systemImage: importance.symbolName)
                        .tag(importance)
                }
            } label: {
                Label("Importance", systemImage: workingImportance.symbolName)
                    .contentTransition(.symbolEffect)
                    .labelStyle(.tintedIcon(icon: workingImportance.color))
            }
            .tint(.secondary)
            
            
            LabeledContent {
                let workingQuantityString = Binding<String>(
                    get: { "\(workingQuantity == .zero ? "" : "\(formatDouble(workingQuantity))")" },
                    set: {
                        if let new = Double($0) {
                            workingQuantity = new
                        }
                    }
                )
                
                let workingUnitsString = Binding<String>(
                    get: { workingUnits.lowercased() },
                    set: { workingUnits = $0.lowercased() }
                )
                
                HStack {
                    TextField("2", text: workingQuantityString)
                        .numbersOnly(workingQuantityString, includeDecimal: true)
                    
                    TextField("cups", text: workingUnitsString)
                        .autocorrectionDisabled()
                }
                .frame(maxWidth: 100)
            } label: {
                Label("Quantity", systemImage: Symbols.quantity)
                    .labelStyle(.tintedIcon(icon: Color.primary.mix(with: Color.secondary, by: 0.75)))
            }
        } header: {
            HStack {
                Text("Properties")
                
                Spacer()
                
                if hasSetProperties {
                    Button("Reset", systemImage: Symbols.reset, action: resetProperties)
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
    
    var grocerySection: some View {
        Group {
            TextField("Title", text: $workingTitle)
            
            let workingCategoryBinding = Binding<GroceryCategory>(
                get: { workingCategory },
                set: {
                    workingCategory = $0
                    hasSetCategory = .set
                }
            )
            
            Picker(selection: workingCategoryBinding) {
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
                    if hasSetCategory == .generating {
                        ProgressView()
                    } else {
                        Image(systemName: workingCategory.symbolName)
                            .contentTransition(.symbolEffect)
                    }
                }
                .labelStyle(.tintedIcon(icon: workingCategory.color))
                .animation(.easeInOut, value: hasSetCategory == .generating)
            }
            .tint(.secondary)
            .onAppear { Task { await generateCategoryOnAppear() } }
            .onChange(of: workingTitle) { Task { await generateCategoryOnAppear() } }
            
            Picker(selection: $workingList) {
                ForEach(GroceryList.allCases) { list in
                    Label(list.name, systemImage: list.symbolName)
                        .tint(list.color)
                        .tag(list)
                }
            } label: {
                Label("List", systemImage: workingList.symbolName)
                    .contentTransition(.symbolEffect)
                    .labelStyle(.tintedIcon(icon: workingList.color))
            }
            .tint(.secondary)
        }
    }
    
    var contents: some View {
        Group {
            Section("Grocery") {
                grocerySection
            }
            
            if workingList == .active {
                propertiesSection
            }
            
            Section {
                ComposerTextEditorView(text: $workingNotes, selection: $selection, placeholder: "You can use Markdown here. ...")
                    .frame(minHeight: 160)
                    
            } header: {
                HStack {
                    Text("Notes")
                    Spacer()
                    
                    if hasSetNotes {
                        Button("Reset", systemImage: Symbols.reset) { workingNotes = "" }
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
                    "Are you sure you would like to delete this grocery?",
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
                .disabled(workingTitle.isEmpty)
            }
            
            ToolbarItem(placement: .principal) {
                Text(grocery != nil ? "Edit" : "Create")
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
            .animation(.easeInOut, value: workingList == .active)
        }
        #elseif os(macOS)
        ScrollView {
            VStack(alignment: .leading) { contents }
            .padding()
            .padding()
        }
        .background { BackgroundView() }
        .toolbar { toolbar }
        .animation(.easeInOut, value: workingList == .active)
        #endif
    }
    
    var hasSetNotes: Bool { !workingNotes.characters.isEmpty }
    
    var hasSetProperties: Bool {
        !(workingCompleted == false && workingUncertain == false && workingImportance == .none && workingPinned == false && workingQuantity == 0 && workingUnits.isEmpty)
    }
    
    func resetProperties() {
        workingCompleted = false
        workingUncertain = false
        workingImportance = .none
        workingPinned = false
        workingQuantity = 0
        workingUnits = ""
    }
    
    func resetNotes() {
        workingNotes = ""
    }
    
    func formatDouble(_ value: Double) -> String {
       let str = String(value)
       return str.hasSuffix(".0") ? String(str.dropLast(2)) : str
    }
    
    func delete() {
        if let grocery = grocery {
            modelContext.delete(grocery)
        }
        dismiss()
    }
    
    func saveChanges() {
        if grocery == nil {
            // create a new grocery
            let g = Grocery(
                list: workingList,
                title: workingTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                completed: workingCompleted,
                notes: String(workingNotes.characters),
                certainty: workingUncertain,
                importance: workingImportance,
                pinned: workingPinned,
                quantity: workingQuantity,
                unit: workingUnits,
                category: workingCategory
            )
            modelContext.insert(g)
        } else {
            // Update all relevant fields
            grocery?.title = workingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            grocery?.setList(workingList)
            grocery?.setCompleted(to: workingCompleted)
            grocery?.setPinned(to: workingPinned)
            grocery?.setCertainty(to: workingUncertain)
            grocery?.setImportance(workingImportance)
            grocery?.quantity = workingQuantity
            grocery?.unit = workingUnits
            grocery?.notes = String(workingNotes.characters)
            grocery?.setCategory(to: workingCategory)
        }
        dismiss()
    }
    
    func generateCategoryOnAppear() async {
        if !workingTitle.isEmpty && hasSetCategory == .unset {
            hasSetCategory = .generating
            do {
                workingCategory = try await GroceryCategory.decideCategory(for: workingTitle)
                hasSetCategory = .set
            } catch {
                print(error)
                hasSetCategory = .unset
            }
        }
    }
}


#Preview {
    BackgroundView()
        .sheet(isPresented: .constant(true)) {
            GroceryDetailView(
                grocery: Grocery.examples.randomElement()
            )
        }
        .applyEnvironment(prePopulate: true)
}
