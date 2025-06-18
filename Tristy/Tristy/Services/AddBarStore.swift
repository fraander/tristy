//
//  Store.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Observation
import SwiftUI
import SwiftData
import OSLog



@Observable
class AddBarStore {
    init(query: String = "") {
        self.query = query
    }
    
    private(set) var query: String = ""
    var listToAddTo: GroceryList = .active
    
    var listToAddToBinding: Binding<GroceryList> {
        .init(
            get: { self.listToAddTo },
            set: { self.listToAddTo = $0 }
        )
    }
    
    var queryBinding: Binding<String> { .init(get: { self.query }, set: { self.query = $0 }) }
    var queryIsEmpty: Bool { query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    /// Using the current value in the `addBarQuery`, add new groceries.
    /// Each new line is treated as its own grocery, and any duplicate groceries are not added.
    /// ## Usage:
    /// ```swift
    ///  // Import
    ///  import SwiftData
    ///
    ///  // Property
    ///  @Environment(\.modelContext) var modelContext
    ///
    ///  // Call
    ///  Task { try abStore.addGroceries(to: modelContext) }
    ///  ```
    /// - Parameter context: ModelContext for all existing groceries in the app
    @MainActor
    func addGroceries(to context: ModelContext) throws {
        if (!self.query.isEmpty) { // no action if no query
            
            // fetch existing groceries; otherwise fail quietly
            guard let existing = try? context.fetch(FetchDescriptor<Grocery>()) else {
                throw SwiftDataError.invalidTransactionFetchRequest
            }
            
            let parts = self.query.components(separatedBy: .newlines)
            for part in parts {
                let trimmed = part.trimmingCharacters(in: .whitespaces)
                if let found = existing.first(where: { g in
                    g.titleOrEmpty.lowercased() == trimmed.lowercased()
                }) {
                    found.clearOptionalData()
                    found.list = GroceryList.active.rawValue
                } else {
                    let grocery = Grocery(title: trimmed)
                    context.insert(grocery)
                }
            }
            
            clearQuery()
        }
    }
    
    func appendToQuery(_ string: String) {
        query.append(contentsOf: string)
    }
    
    /// Reset the `addBarQuery` value to empty string
    func clearQuery() {
        query = ""
    }
}
