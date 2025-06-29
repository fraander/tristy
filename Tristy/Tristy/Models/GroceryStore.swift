//
//  GroceryStore.swift
//  Tristy
//
//  Created by Frank Anderson on 6/29/25.
//

import SwiftData
import SwiftUI

@Model
class GroceryStore {
    var name: String?
    var symbolName: String?
    
    var red: CGFloat?
    var green: CGFloat?
    var blue: CGFloat?
    
    @Relationship(deleteRule: .cascade) // Circular reference resolving attached macro 'Relationship'
    var groceries: [Grocery]? = []
    
    init(
        name: String? = nil,
        symbolName: String? = nil,
        color: Color? = nil,
    ) {
        self.name = name
        self.symbolName = symbolName
        
        if let c = color {
            updateColor(with: c)
        }
    }
    
    var nameOrEmpty: String { self.name ?? "" }
    var symbolOrDefault: String { self.symbolName ?? Symbols.basket }
    var colorOrDefault: Color {
        if let r = red, let g = green, let b = blue {
            return Color(red: r, green: g, blue: b)
        } else {
            return Color.secondary
        }
    }
    
    var colorBinding: Binding<Color> {
        .init(
            get: { self.colorOrDefault },
            set: { self.updateColor(with: $0) }
        )
    }
    
    func updateColor(with color: Color) {
        let resolved = color.resolve(in: EnvironmentValues())
        self.red = CGFloat(resolved.red)
        self.green = CGFloat(resolved.green)
        self.blue = CGFloat(resolved.blue)
    }
    
    static let examples = [
        GroceryStore(name: "Trader Joe's", symbolName: "cart", color: .red),
        GroceryStore(name: "Whole Foods", symbolName: "leaf", color: .green),
        GroceryStore(name: "Stop & Shop", symbolName: "storefront", color: .blue),
        GroceryStore(name: "Star Market", symbolName: "star", color: .orange),
        GroceryStore(name: "Market Basket", symbolName: "basket", color: .purple)
    ]
}
