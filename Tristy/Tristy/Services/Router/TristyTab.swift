//
//  TristyTab.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

enum TristyTab: Identifiable, Hashable {
    case list([GroceryList])
//    case settings
    
    var rawValue: String {
        switch self {
        case .list(let v):
            if (v == [.active, .nextTime, .archive]) {
                return "Shop"
            } else if (v == [.active]) {
                return GroceryList.active.name
            } else if v.contains(.archive) {
                return GroceryList.archive.name
            } else if v == [.nextTime] {
                return GroceryList.nextTime.name
            } else {
                return "Shop"
            }
        }
    }
    
    var id: String {
        switch self {
        case .list(let v): "List_\(v.map { String($0.id) }.joined(separator: "_"))"
        }
    }
    
    var symbolName: String {
        switch self {
        case .list(let v):
            if (v == [.active, .nextTime, .archive]) {
                return "cart.fill"
            } else if (v == [.active]) {
                return GroceryList.active.symbolName
            } else if v.contains(.archive) {
                return GroceryList.archive.symbolName
            } else if v == [.nextTime] {
                return GroceryList.nextTime.symbolName
            } else {
                return "cart.fill"
            }
        }
    }
    
    var role: TabRole? {
        switch self {
//        case .search: return .search
        default: return nil
        }
    }
    
    var correspondingView: some View {
        switch self {
        case .list(let v): ShoppingListView(showingLists: v)
        }
    }
}
