//
//  Store.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Observation
import SwiftUI

@Observable
class Store {
    private(set) var addBarQuery: String = ""
    var addBarQueryBinding: Binding<String> { .init(get: { self.addBarQuery }, set: { self.addBarQuery = $0 }) }
    
    /// Using the current value in the `addBarQuery`, add new groceries
    func addGroceries() {
        print(addBarQuery)
        
        addBarQuery = ""
    }
    
    /// Reset the `addBarQuery` value to empty string
    func clearAddBarQuery() {
        self.addBarQuery = ""
    }
    
    func appendToAddBarQuery(_ string: String) {
        self.addBarQuery += string
    }
}
