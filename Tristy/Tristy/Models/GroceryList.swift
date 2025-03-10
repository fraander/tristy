//
//  GroceryList.swift
//  Tristy
//
//  Created by Frank Anderson on 4/29/24.
//

import Foundation

enum GroceryList: Codable, CustomStringConvertible, CaseIterable, Identifiable {
    
    static var allCases: [GroceryList] = [.today, .nextTime, .eventually]
    
    var description: String {
        switch self {
        case .today: "Today"
        case .nextTime: "Next Time"
        case .eventually: "Eventually"
        }
    }
    
    static func toEnum(_ string: String) -> GroceryList? {
        switch string {
        case GroceryList.today.description: GroceryList.today
        case GroceryList.nextTime.description: GroceryList.nextTime
        case GroceryList.eventually.description: GroceryList.eventually
        default: nil
        }
    }
    
    var symbol: String {
        switch self {
        case .today: "smallcircle.filled.circle"
        case .nextTime: "alternatingcurrent"
        case .eventually: "arrow.right"
        }
    }
    
    case today, nextTime, eventually
    
    var id: Self { self }
}
