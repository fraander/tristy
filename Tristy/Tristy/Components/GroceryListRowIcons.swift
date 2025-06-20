//
//  GroceryListRowIcons.swift
//  Tristy
//
//  Created by Frank Anderson on 6/19/25.
//

import SwiftUI

struct GroceryListRowIcons: View {
    
    @AppStorage(Settings.Icons.key) var icons = Settings.Icons.defaultValue
    var grocery: Grocery
    
    typealias Icon = Settings.Icons.Icon
    
    @ViewBuilder
    func quantityIcon() -> some View {
        let quantityCondition = grocery.quantityOrEmpty != 0
        if (quantityCondition) {
            Text("\(formatAsMixedNumber(grocery.quantityOrEmpty)) \(grocery.unitOrEmpty)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle( Color.primary.mix(with: .secondary, by: 0.75) )
        }
    }
    
    @ViewBuilder
    func uncertainIcon() -> some View {
        if (grocery.isUncertain) {
            Image(systemName: Symbols.uncertain)
                .symbolToggleEffect(grocery.isUncertain)
                .foregroundStyle(.indigo)
        }
    }
    
    @ViewBuilder
    func notesIcon() -> some View {
        let notesCondition = !grocery.notesOrEmpty.isEmpty
        if (notesCondition) {
            Image(systemName: Symbols.notes)
                .symbolToggleEffect(notesCondition)
                .foregroundStyle(.yellow)
        }
    }
    
    @ViewBuilder
    func importanceIcon() -> some View {
        let importanceCondition = grocery.importanceEnum != .none
        if (importanceCondition) {
            Image(systemName: grocery.importanceEnum.symbolName)
                .foregroundStyle(grocery.importanceEnum.color)
        }
    }
    
    @ViewBuilder
    func pinIcon() -> some View {
        if (grocery.isPinned) {
            Image(systemName: Symbols.pinned)
                .symbolToggleEffect(grocery.isPinned)
                .foregroundStyle(.orange)
        }
    }
    
    @ViewBuilder
    func categoryIcon() -> some View {
        let categoryCondition = grocery.categoryEnum != .other
        if (categoryCondition) {
            Image(systemName: grocery.categoryEnum.symbolName)
                .foregroundStyle(grocery.categoryEnum.color)
        }
    }
    
    @ViewBuilder
    func correspondingView(icon: Icon) -> some View {
        switch icon {
        case .qty: quantityIcon()
        case .uncertain: uncertainIcon()
        case .note: notesIcon()
        case .importance: importanceIcon()
        case .pin: pinIcon()
        case .category: categoryIcon()
        case .none: Text("")
        }
    }
    
    var body: some View {
        HStack {
            ForEach(icons) { icon in
                if icon != .none {
                    correspondingView(icon: icon)
                }
            }
        }
    }
    
    func formatAsMixedNumber(_ value: Double) -> String {
        let whole = Int(value)
        let fractional = value - Double(whole)
        
        if abs(fractional) < 0.001 { return "\(whole)" }
        
        // Common denominators to check
        let denominators = [2, 3, 4, 5, 6, 8]
        
        for denom in denominators {
            let num = Int(round(fractional * Double(denom)))
            if abs(fractional - Double(num) / Double(denom)) < 0.001 {
                let gcd = gcd(abs(num), denom)
                let simplifiedNum = num / gcd
                let simplifiedDenom = denom / gcd
                
                let fractionStr = "\(simplifiedNum)/\(simplifiedDenom)"
                return whole == 0 ? fractionStr : "\(whole) \(fractionStr)"
            }
        }
        
        return String(format: "%.3f", value) // fallback to decimal
    }
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
    }
}
