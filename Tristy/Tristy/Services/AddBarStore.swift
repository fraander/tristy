//
//  Store.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Observation
import SwiftUI

@Observable
class AddBarStore {
    
    init(query: String = "", isFocused: Bool = false) {
        self.query = query
        self.isFocused = isFocused
    }
    
    
    private(set) var query: String = ""
    var isFocused: Bool = false
    
    var queryBinding: Binding<String> { .init(get: { self.query }, set: { self.query = $0 }) }
    
    var queryIsEmpty: Bool { query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    /// Using the current value in the `addBarQuery`, add new groceries
    func addGroceries() {
        print(query)
        
        clearQuery()
    }
    
    func appendToQuery(_ string: String) {
        query.append(contentsOf: string)
    }
    
    
    /// Reset the `addBarQuery` value to empty string
    func clearQuery() {
        query = ""
    }
}
