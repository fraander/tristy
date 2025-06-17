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
    
    @State var workingTitle: String = ""
    @State var workingList: GroceryList = .active
    @State var workingCompleted: Bool = false
    @State var workingPinned: Bool = false
    @State var workingUncertain: Bool = false
    @State var workingImportance: GroceryImportance = .none
    @State var workingQuantity: Double = .zero
    @State var workingUnits: String = ""
    @State var workingNotes: String = ""
    
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
                        .frame(minHeight: 240)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        saveChanges()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(grocery != nil ? "Edit" : "Create")
                }
            }
            .task { initialSetup() }
        }
    }
    
    func saveChanges() {
        guard (grocery != nil) else { return }
        
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
    
    func initialSetup() {
        
        // If given a grocery to populate with, use it ...
        if let grocery {
            workingTitle = grocery.titleOrEmpty
            workingList = grocery.listEnum
            workingCompleted = grocery.isCompleted
            workingPinned = grocery.isPinned
            workingUncertain = grocery.isUncertain
            workingImportance = grocery.importanceEnum
            workingQuantity = grocery.quantityOrEmpty
            workingUnits = grocery.unitOrEmpty
            workingNotes = grocery.notesOrEmpty
        }
    }
}


#Preview {
    BackgroundView()
        .sheet(isPresented: .constant(true)) {
            GroceryDetailView(grocery: nil)
        }
        .applyEnvironment(prePopulate: true)
}
