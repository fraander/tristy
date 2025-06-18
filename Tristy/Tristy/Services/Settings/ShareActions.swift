//
//  ShareActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/18/25.
//

import SwiftUI
import SwiftData

struct ShareActions: View {
    @Environment(\.modelContext) var modelContext
    
    @State var showConfirmationAlert: Bool = false
    
    var body: some View {
        Group {
            Button("Copy \(GroceryList.active.name)", systemImage: Symbols.copy, action: copyActive)
                .labelStyle(.tintedIcon())
                .alert("The list has been copied to your clipboard", isPresented: $showConfirmationAlert) {}
        }
    }
    
    func copyActive() {
        let listInt = GroceryList.active.rawValue
        let descriptor = FetchDescriptor<Grocery>(predicate: #Predicate { $0.list == listInt })
        if let groceries = try? modelContext.fetch(descriptor) {
            let string = "# Shopping List\n" + groceries.map { groceryToMarkdown($0) }.joined(separator: "\n")
            #if os(iOS)
            UIPasteboard.general.string = string
            #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(string, forType: .string)
            #endif
        }
        
        showConfirmationAlert = true
    }
    
    func groceryToMarkdown(_ grocery: Grocery) -> String {
        let p1 = (grocery.isCompleted ? "- [ ]" : "- [x]")
        let p2 = grocery.titleOrEmpty
        let p3 = (grocery.importanceEnum == .somewhat ? "❗" : (grocery.importanceEnum == .very ? "‼️" : ""))
        let p4 = (grocery.isUncertain ? "❓" : "")
        let p5 = (grocery.quantityOrEmpty == 0 ? "" : "(\(grocery.quantityOrEmpty) \(grocery.unitOrEmpty))")
        
        return p1 + " " + p2 + p3 + p4 + p5
    }
}

#Preview {
    List {
        ShareActions()
    }
    .applyEnvironment()
}
