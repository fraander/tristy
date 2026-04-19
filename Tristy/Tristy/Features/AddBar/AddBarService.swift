//
//  AddBar.swift
//  Tristy
//
//  Created by frank on 3/21/26.
//

import Observation
import SwiftData

@Observable
class AddBarService {
    
    var modelContext: ModelContext? = nil
    
    private var _query: String = ""
    private var _isSearching: Bool = false
    
    var query: String {
        get { _query }
        set {
            guard _query != newValue else { return }
            _query = newValue
            fetchGroceries()
        }
    }
    
    var isSearching: Bool {
        get { _isSearching }
        set {
            guard _isSearching != newValue else { return }
            _isSearching = newValue
            fetchGroceries()
        }
    }
    
    var showPlusButton: Bool {
        !trimmedQuery.isEmpty && !filteredItems.map(\.titleOrEmpty).contains(trimmedQuery)
    }
    
    var filteredItems: [Grocery] = []
    
    init() { }
    
    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fetchGroceries() {
        let fetchDescriptor = FetchDescriptor<Grocery>()
        let groceries = (try? modelContext?.fetch(fetchDescriptor) ?? []) ?? []
        filteredItems = findClosestGroceries(for: query, in: groceries)
    }
    
    func moveGroceryToActive(grocery: Grocery) {
        query = ""
        grocery.setList(.active)
        fetchGroceries()
    }
    
    func createGroceryFromQuery() {
        let newGrocery = Grocery(list: .active, title: trimmedQuery)
        modelContext?.insert(newGrocery)
        fetchGroceries()
    }
    
    func findClosestGroceries(for title: String, in groceries: [Grocery], limit: Int = 6) -> [Grocery] {
        let searchTitle = title.lowercased()
        
        return groceries
            .compactMap { grocery -> (Grocery, Int)? in
                let groceryTitle = grocery.titleOrEmpty.lowercased()
                guard !groceryTitle.isEmpty else { return nil }
                
                var score = 0
                if groceryTitle == searchTitle { score = 100 }
                else if groceryTitle.hasPrefix(searchTitle) { score = 80 }
                else if searchTitle.hasPrefix(groceryTitle) { score = 70 }
                else if groceryTitle.contains(searchTitle) { score = 60 }
                else if searchTitle.contains(groceryTitle) { score = 50 }
                else { return nil }
                
                return (grocery, score)
            }
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { $0.0 }
    }
}
