//
//  TristyTab.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

enum TristyTab: String, CaseIterable, Codable, Identifiable {
    case today = "Shop"
    case archive = "Archive"
//    case plan = "Plan"
//    case search = "Search"
    
    var id: String { self.rawValue }
    
    var symbolName: String {
        switch self {
        case .today: "cart.fill"
        case .archive: "archivebox.fill"
//        case .plan: "calendar.day.timeline.left"
//        case .search: "magnifyingglass"
        }
    }
    
    var role: TabRole? {
        switch self {
        case .today: return nil
        case .archive: return nil
//        case .plan: return nil
//        case .search: return .search
        }
    }
    
    @ViewBuilder
    var correspondingView: some View {
        switch self {
        case .today: ShoppingListView()
        case .archive: ArchiveView()
//        case .plan: Text("Plan")
//        case .search: ZStack {Text(self.rawValue)}.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    /// Customized order for all cases in enum `Tab`
    static let allCases: [TristyTab] = [
        .today,
        .archive,
//        .plan,
//        .search,
    ]
}
