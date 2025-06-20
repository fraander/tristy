//
//  DataActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/13/25.
//

import SwiftUI
import SwiftData


struct DataActions: View {
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    
    @State var isShowingDeleteAllConfirmation: Bool = false
    @State var deleteAllAlertIsPresented: Bool = false
    
    @State var isShowingPrePopulateConfirmation: Bool = false
    
    func insertExamples() {
        for grocery in Grocery.examples {
            modelContext.insert(grocery)
        }
    }
    
    func deleteAll() async {
        do {
            try modelContext.fetch(FetchDescriptor<Grocery>()).forEach {
                modelContext.delete($0)
            }
        } catch {
            deleteAllAlertIsPresented = true
        }
    }
    
    var body: some View {
        Group {
            Button("Populate", systemImage: Symbols.populate) {
                isShowingPrePopulateConfirmation = true
            }
            .labelStyle(.tintedIcon())
            .confirmationDialog(
                "To confirm, you would like to add a pre-written set of example groceries to your database?",
                isPresented: $isShowingPrePopulateConfirmation,
                titleVisibility: .visible,
                actions: {
                    Button("No, Cancel", role: .cancel) { isShowingDeleteAllConfirmation = false }
                    Button("Yes, Populate", systemImage: "checkmark", action: insertExamples)
                },
                message: { Text("This cannot be reverted.") }
            )
            
            Button("Delete All", systemImage: Symbols.delete, role: .destructive) {
                isShowingDeleteAllConfirmation = true
            }
            .labelStyle(.tintedIcon(icon: .pink))
            .confirmationDialog(
                "To confirm, you would like to delete all your Groceries?",
                isPresented: $isShowingDeleteAllConfirmation,
                titleVisibility: .visible,
                actions: {
                    Button("No, Cancel", role: .cancel) { isShowingDeleteAllConfirmation = false }
                    Button("Yes, Delete", role: .destructive) { Task { await deleteAll() } }
                },
                message: { Text("This cannot be reverted.") }
            )
            .alert(
                "Failed to delete all Groceries",
                isPresented: $deleteAllAlertIsPresented,
                actions: {},
                message: { Text("Please try again.") }
            )
        }
    }
}

#Preview {
    List {
        DataActions()
    }
    .applyEnvironment()
}
