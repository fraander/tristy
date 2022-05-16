//
//  TristyListItem.swift
//  Tristy
//
//  Created by Frank Anderson on 5/15/22.
//

import Foundation

/// One item in a list
struct TristyListItem: Codable, Identifiable, Hashable {
    
    static let example = TristyListItem(id: UUID(), title: "New list item that has a long name that's annoyingly long", notes: "New list item that has a long name that's annoyingly long's description.", priority: .none, isComplete: false)
    
    /// The priority for a single item; uses `CaseIterable` so we loop over all three cases in `DetailView`.
    enum Priority: String, Codable, CaseIterable {
        case none = "None"
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    /// A unique, random identifier for this item
    var id = UUID()
    
    /// Date of the item's creation
    var dateCreated = Date()
    
    /// The user-facing title of this item
    var title = ""
    
    /// The notes about the item
    var notes = ""
    
    /// The current priority for this item.
    var priority = Priority.medium
    
    /// Whether this item has been completed or not.
    var isComplete = false
    
    /// The value of the item, to convey this information to assistive technologies.
    var accessibilityValue: String {
        if isComplete {
            return "completed"
        } else {
            switch priority {
                case .none:
                    return "" // no label for default to prevent verbosity
                case .low:
                    return "low priority"
                case .medium:
                    return "medium priority"
                case .high:
                    return "high priority"
            }
        }
    }
}
