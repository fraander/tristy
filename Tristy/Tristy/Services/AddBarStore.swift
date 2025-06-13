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

enum FocusOption: Identifiable, Equatable, Hashable {
    case addBar
    case grocery(PersistentIdentifier)
    
    var id: String {
        switch self {
        case .addBar:
            "addBar"
        case .grocery(let id):
            "grocery - \(id.storeIdentifier ?? "ERROR")"
        }
    }
}

@Observable
class AddBarStore {
    
    init(query: String = "", focus: FocusOption? = nil) {
        self.query = query
        self.focus = focus
    }
    
    
    private(set) var query: String = ""
    private(set) var focus: FocusOption?
    
    /// Accept change in focus if to == for
    /// - Parameters:
    ///   - prevOption: What the focus value used to be at the call site
    ///   - newOption: What the new focus value should be at the call site
    ///   - source: Which caller is setting focus
    func setFocus(from prevOption: FocusOption? , to newOption: FocusOption?, for source: FocusOption) {
        if newOption == source {
            self.focus = newOption
        }
    }
    
    /// Set focus to nil - explicit call required
    func removeFocus() {
        self.focus = nil
    }
    
    var isAddBarFocused: Bool {
        focus == .addBar
    }
    
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
