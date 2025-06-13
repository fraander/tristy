//
//  TristyTab.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

enum TristyTab: String, CaseIterable, Codable, Identifiable {
    case shoppingList = "List"
    case allItems = "Archive"
//    case search = "Search"
    
    var id: String { self.rawValue }
    
    var symbolName: String {
        switch self {
        case .shoppingList: "cart.fill"
        case .allItems: "archivebox.fill"
//        case .search: "magnifyingglass"
        }
    }
    
    var role: TabRole? {
        switch self {
        case .shoppingList: return nil
        case .allItems: return nil
//        case .search: return .search
        }
    }
    
    @ViewBuilder
    var correspondingView: some View {
        switch self {
        case .shoppingList: ShoppingListView()
        case .allItems: ArchiveView()
//        case .search: ZStack {Text(self.rawValue)}.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    /// Customized order for all cases in enum `Tab`
    static let allCases: [TristyTab] = [
        .shoppingList,
        .allItems,
//        .search
    ]
}
