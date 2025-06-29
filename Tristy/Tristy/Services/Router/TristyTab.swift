//
//  TristyTab.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

enum TristyTab: Identifiable {
    case today([GroceryList])
    case nextTime([GroceryList])
    case archive([GroceryList])
    
    var id: String {
        switch self {
        case .today(let v): "Today_\(v.map { String($0.id) }.joined(separator: "_"))"
        case .nextTime(let v): "Next_\(v.map { String($0.id) }.joined(separator: "_"))"
        case .archive(let v): "Archive_\(v.map { String($0.id) }.joined(separator: "_"))"
        }
    }
    
    var symbolName: String {
        switch self {
        case .today: GroceryList.active.symbolName
        case .archive: GroceryList.archive.symbolName
        case .nextTime: GroceryList.nextTime.symbolName
//        case .plan: "calendar.day.timeline.left"
//        case .search: "magnifyingglass"
        }
    }
    
    var role: TabRole? {
        switch self {
//        case .search: return .search
        default: return nil
        }
    }
}
