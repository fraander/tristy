//
//  Grocery.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftData
import SwiftUI

#Preview {
    VStack {
        ForEach(GroceryList.allCases) { gl in
            gl.color
        }
        
        Divider()
        
        ForEach(GroceryImportance.allCases) { gl in
            gl.color
        }
    }
}

enum GroceryList: Int, RawRepresentable, CaseIterable, Identifiable {
    case active = 0
    case nextTime = 1
    case archive = 2
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .active: "Today"
        case .nextTime: "Next Time"
        case .archive: "Archive"
        }
    }
    
    var symbolName: String {
        switch self {
        case .active: "smallcircle.filled.circle"
        case .nextTime: "arrow.right"
        case .archive: "archivebox"
        }
    }
    
    var color: Color {
        switch self {
        case .active: .accentColor
        case .nextTime: .indigo
        case .archive: .secondary
        }
    }
}

enum GroceryImportance: Int, RawRepresentable, Identifiable, CaseIterable {
    case none = 0
    case somewhat = 1
    case very = 2
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .none: "None"
        case .somewhat: "Somewhat"
        case .very: "Very"
        }
    }
    
    var color: Color {
        switch self {
        case .none: .secondary
        case .somewhat: .orange.mix(with: .yellow, by: 0.5)
        case .very: .orange.mix(with: .red, by: 0.5)
        }
    }
    
    var symbolName: String {
        switch self {
        case .none: "circle.slash"
        case .somewhat: "exclamationmark"
        case .very: "exclamationmark.2"
        }
    }
}

/// A Grocery in the list
@Model
class Grocery {
    
    // MARK: Properties -
    /// Which list is the item in. [0 = active list, 1 = next time, 2 = archive]
    var list: Int?
    
    /// The name of the grocery / ingredient
    var title: String?
    /// Has the item been retrieved? [0 = no, 1 = yes]
    var completed: Int?
    
    /// Any special notes about the item, not obvious from the title.
    var notes: String?
    
    /// Shows as nothing or ? on the label. [0 = no, 1 = yes]
    var certainty: Int?
    /// Shows as nothing or ! or !! on the label. [0 = nothing, 1 = !, 2 = !!]
    var importance: Int?
    /// Is the item pinned to the .active list? [0 = no, 1 = yes]
    var pinned: Int?
    
    /// Any numeric value, either Integer or Decimal
    var quantity: Double?
    /// Stored as String, could be anything of the user's choice.
    var unit: String?
    
    // Read-only computed properties with nil handling
    var titleOrEmpty: String { title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
    var notesOrEmpty: String { notes ?? "" }
    var isCompleted: Bool { completed == 1 }
    var isUncertain: Bool { certainty == 1 }
    var isPinned: Bool { pinned == 1 }
    var listEnum: GroceryList { GroceryList(rawValue: list ?? 0) ?? .active }
    var importanceEnum: GroceryImportance { GroceryImportance(rawValue: importance ?? 0) ?? .none }
    var quantityOrEmpty: Double { self.quantity ?? 0.0 }
    var unitOrEmpty: String { self.unit?.lowercased() ?? "" }
    
    // Methods for updates
    func setCompleted(to value: Bool) { completed = value ? 1 : 0 }
    func setCertainty(to value: Bool) { certainty = value ? 1 : 0 }
    func setPinned(to value: Bool) { pinned = value ? 1 : 0 }
    func setList(_ value: GroceryList) {
        list = value.rawValue
        setCompleted(to: false)
    }
    func setImportance(_ value: GroceryImportance) { importance = value.rawValue }
    
    // MARK: Initializers -
    
    init(list: GroceryList = .active, title: String = "", completed: Bool = false, notes: String = "", certainty: Bool = false, importance: GroceryImportance = .none, pinned: Bool = false, quantity: Double = 0, unit: String = "") {
        self.list = list.rawValue
        self.title = title
        self.completed = completed ? 1 : 0
        self.notes = notes
        self.certainty = certainty ? 1 : 0
        self.importance = importance.rawValue
        self.pinned = pinned ? 1 : 0
        self.quantity = quantity
        self.unit = unit
    }
    
    // MARK: Functions -
    
    /// Set complete to the opposite of its current value
    func toggleCompleted() {
        setCompleted(to: !isCompleted)
    }
    
    /// Clear all optional properties to default values.
    func clearOptionalData() {
        notes = ""
        certainty = 0
        importance = 0
        quantity = 0
        unit = ""
    }
    
    // MARK: Examples -
    static let examples: [Grocery] = [
        // Active list items
        Grocery(list: .active, title: "Milk", quantity: 1, unit: "gallon"),
        Grocery(list: .active, title: "Bread", completed: true, pinned: true),
        Grocery(list: .active, title: "Eggs", importance: .very),
        Grocery(list: .active, title: "Bananas", notes: "Not too ripe"),
        Grocery(list: .active, title: "Chicken Breast", notes: "Organic if available", importance: .somewhat, pinned: true, quantity: 2, unit: "lbs"),
        Grocery(list: .active, title: "Rice", pinned: true),
        Grocery(list: .active, title: "Onions", completed: true),
        Grocery(list: .active, title: "Tomatoes", certainty: true),
        Grocery(list: .active, title: "Cheese", notes: "Sharp cheddar"),
        Grocery(list: .active, title: "Apples", completed: true),
        
        // Next time list
        Grocery(list: .nextTime, title: "Ground Beef", notes: "85/15 lean"),
        Grocery(list: .nextTime, title: "Pasta"),
        Grocery(list: .nextTime, title: "Olive Oil", notes: "Extra virgin", pinned: true),
        Grocery(list: .nextTime, title: "Yogurt", certainty: true, quantity: 6, unit: "cups"),
        Grocery(list: .nextTime, title: "Spinach", importance: .somewhat),
        Grocery(list: .nextTime, title: "Carrots"),
        Grocery(list: .nextTime, title: "Bell Peppers", notes: "Mix of colors", pinned: true),
        Grocery(list: .nextTime, title: "Garlic"),
        Grocery(list: .nextTime, title: "Potatoes", quantity: 5, unit: "lbs"),
        Grocery(list: .nextTime, title: "Salmon", importance: .very, pinned: true),
        
        // Archive
        Grocery(list: .archive, title: "Broccoli", completed: true, notes: "Got frozen instead", pinned: true),
        Grocery(list: .archive, title: "Orange Juice", completed: true),
        Grocery(list: .archive, title: "Butter", completed: true, notes: "Unsalted"),
        Grocery(list: .archive, title: "Cereal", completed: true),
        Grocery(list: .archive, title: "Strawberries", completed: true, pinned: true),
        Grocery(list: .archive, title: "Avocados", completed: true),
        Grocery(list: .archive, title: "Lemon", completed: true),
        Grocery(list: .archive, title: "Mushrooms", completed: true),
        Grocery(list: .archive, title: "Frozen Peas", completed: true, pinned: true),
        Grocery(list: .archive, title: "Canned Beans", completed: true, notes: "Black beans and chickpeas")
    ]
}

