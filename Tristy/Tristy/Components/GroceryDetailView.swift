//
//  GroceryDetailView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/16/25.
//

import SwiftUI

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
            _workingNotes = .init(initialValue: grocery.notesOrEmpty)
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
    @State var workingNotes: String = ""
    
    @State var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Grocery") {
                    TextField("Title", text: $workingTitle)
                }
                
                Section("Properties") {
                    
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
                    
                    Toggle("Completed", systemImage: "checkmark.circle", isOn: $workingCompleted)
                    .labelStyle(.tintedIcon(icon: .mint))
                    .symbolToggleEffectViewModifier(workingCompleted)
                    
                    Toggle("Pinned", systemImage: "pin", isOn: $workingPinned)
                    .labelStyle(.tintedIcon(icon: .orange))
                    .symbolToggleEffectViewModifier(workingPinned)
                    
                    Toggle("Uncertain", systemImage: "questionmark.app", isOn: $workingUncertain)
                    .labelStyle(.tintedIcon(icon: .indigo))
                    .symbolToggleEffectViewModifier(workingUncertain)
                    
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
                }
                
                Section("Details") {
                    HStack {
                        
                        let workingQuantityString = Binding<String>(
                            get: { "\(workingQuantity == .zero ? "" : "\(workingQuantity)")" },
                            set: {
                                if let new = Double($0) {
                                    workingQuantity = new
                                }
                            }
                        )
                        
                        TextField("Quantity", text: workingQuantityString)
                            .numbersOnly(workingQuantityString, includeDecimal: true)
                        
                        TextField("Unit", text: $workingUnits)
                    }
                    
                    TextEditor(text: $workingNotes)
                        .frame(minHeight: 160)
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
        }
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
                notes: workingNotes,
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
            grocery?.notes = workingNotes
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
