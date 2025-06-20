//
//  GroceryCategory.swift
//  Tristy
//
//  Created by Frank Anderson on 6/19/25.
//

import FoundationModels
import SwiftUI

#warning("add to sort options")

@Generable
enum GroceryCategory: String, CaseIterable, RawRepresentable, Identifiable {
    case produce = "Produce"
    case meat = "Meat & Seafood"
    case dairy = "Dairy"
    case bakery = "Bakery"
    case deli = "Deli"
    case frozen = "Frozen Foods"
    case pantry = "Pantry"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case household = "Household"
    case pharmacy = "Pharmacy"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var color: Color {
       switch self {
       case .produce: return .green
       case .meat: return .red
       case .dairy: return .blue
       case .bakery: return .brown
       case .deli: return .orange
       case .frozen: return .cyan
       case .pantry: return .indigo
       case .beverages: return .purple
       case .snacks: return .pink
       case .household: return .teal
       case .pharmacy: return .mint
       case .other: return .secondary
       }
    }
    
    var symbolName: String {
       switch self {
       case .produce: "carrot"
       case .meat: "fish"
       case .dairy: "drop"
       case .bakery: "birthday.cake"
       case .deli: "takeoutbag.and.cup.and.straw"
       case .frozen: "snowflake"
       case .pantry: "cabinet"
       case .beverages: "cup.and.saucer"
       case .snacks: "bag"
       case .household: "house"
       case .pharmacy: "cross"
       case .other: "questionmark.circle"
       }
    }
    
    init?(rawValue: String) {
        self.init(from: rawValue)
    }
    
    init(from string: String?) {
        self = GroceryCategory.categoryFor(string: string)
    }
    
    static func categoryFor(string: String?) -> GroceryCategory {
        return GroceryCategory.allCases.first(where: { $0.rawValue == string }) ?? .other
    }
    
    static let allCases: [GroceryCategory] = [
        .bakery, .beverages, .dairy, .deli, .frozen, .household, .meat, .pantry, .pharmacy, .produce, .snacks, .other
    ]
    
    var sortOrder: Int {
        switch self {
        case .produce: 1
        case .bakery: 2
        case .deli: 3
        case .meat: 4
        case .dairy: 5
        case .frozen: 6
        case .pantry: 7
        case .beverages: 8
        case .snacks: 9
        case .household: 10
        case .pharmacy: 11
        case .other: 12
        }
    }
    
    static var alphabeticalCases: [GroceryCategory] {
        allCases.sorted { $0.rawValue < $1.rawValue }
    }
    
    /// For a given title, use the FoundationModel to generate a category from the set of choices.
    /// - Parameter title: title of a grocery
    /// - Returns: a GroceryCategory
    static func decideCategory(for title: String) async throws -> GroceryCategory {
        
        let prompt = """
            Based on the grocery item title '\(title)', classify it into one of these categories: bakery, beverages, dairy, deli, frozen, household, meat, pantry, pharmacy, produce, snacks, or other. Choose the most appropriate single category. If the item doesn't clearly fit into any of the first 11 categories, use 'other'.
            """
        
        let session = LanguageModelSession()
        
        do {
            let result = try await session.respond(
                to: prompt,
                generating: GroceryCategory.self
            )
            return result.content
        } catch {
            throw error
        }
    }
}
