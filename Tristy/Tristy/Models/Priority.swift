//
//  Priority.swift
//  Tristy
//
//  Created by Frank Anderson on 5/9/24.
//

import Foundation

enum GroceryPriority: Codable, CustomStringConvertible {
    var description: String {
        switch self {
        case .none: "None"
        case .low: "Unsure"
        case .medium: "Low"
        case .high: "High"
        }
    }
    
    var value: Int {
        return GroceryPriority.toValue(self)
    }
    
    static func toValue(_ gp: GroceryPriority?) -> Int {
        switch gp {
        case .low: 1
        case .medium: 2
        case .high: 3
        default: 0
        }
    }
    
    static func toEnum(_ int: Int) -> GroceryPriority {
        switch int {
        case 1: GroceryPriority.low
        case 2: GroceryPriority.medium
        case 3: GroceryPriority.high
        default: GroceryPriority.none
        }
    }
    
    static let tabs: [GroceryPriority] = [.low, .medium, .high, .none]
    
    var symbol: String {
        switch self {
        case .none: "arrow.down"
        case .low: "questionmark"
        case .medium: "exclamationmark"
        case .high: "exclamationmark.3"
        }
    }
    
    case none, low, medium, high
}
