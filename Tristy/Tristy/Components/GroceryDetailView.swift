//
//  GroceryDetailView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/16/25.
//

import SwiftUI
import AttributedTextEditor

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
    
    @State var showingDeleteConfirmation = false
    @State var selection = AttributedTextSelection()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Grocery") {
                    TextField("Title", text: $workingTitle)
                    
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
                
                if workingList == .active {
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
                        .animation(.easeInOut, value: hasSetProperties)
                    }
                    .transition(.move(edge: .top))
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        saveChanges()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(grocery != nil ? "Edit" : "Create")
                }
            }
            .animation(.easeInOut, value: workingList == .active)
        }
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
                title: workingTitle,
                completed: workingCompleted,
                notes: String(workingNotes.characters),
                certainty: workingUncertain,
                importance: workingImportance,
                pinned: workingPinned,
                quantity: workingQuantity,
                unit: workingUnits
            )
            modelContext.insert(g)
        } else {
            // Update all relevant fields
            grocery?.title = workingTitle
            grocery?.setList(workingList)
            grocery?.setCompleted(to: workingCompleted)
            grocery?.setPinned(to: workingPinned)
            grocery?.setCertainty(to: workingUncertain)
            grocery?.setImportance(workingImportance)
            grocery?.quantity = workingQuantity
            grocery?.unit = workingUnits
            grocery?.notes = String(workingNotes.characters)
        }
        dismiss()
    }
}


#Preview {
    BackgroundView()
        .sheet(isPresented: .constant(true)) {
            GroceryDetailView(grocery: nil)
        }
        .applyEnvironment(prePopulate: true)
}
