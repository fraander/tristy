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
