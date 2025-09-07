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
import FoundationModels



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
    func addGroceries(to context: ModelContext) async throws {
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
                    print("inserted \(grocery.titleOrEmpty)")
                    
                    if let generatedCategory = try? await decideCategory(for: trimmed) {
                        print(generatedCategory)
                        grocery.setCategory(to: generatedCategory)
                    }
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
    
    /// For a given title, use the FoundationModel to generate a category from the set of choices.
    /// - Parameter title: title of a grocery
    /// - Returns: a GroceryCategory
    func decideCategory(for title: String) async throws -> GroceryCategory {
        #warning("causes launch issue")
//        do {
//            let session = LanguageModelSession(instructions: "You are categorizing groceries into what section of the grocery store you would find them. You will be given the name of the grocery, and you will respond with the section. Choose the most appropriate single category. If the item doesn't clearly fit into any of the first 11 categories, use 'other'.")
//            
//            let result = try await session.respond(
//                to: title,
//                generating: GroceryCategory.self,
//            )
//            
//            return result.content
//        } catch {
//            throw error
//        }
        
        return .other
    }
}
