//
//  GroceryList.swift
//  Tristy
//
//  Created by Frank Anderson on 4/29/24.
//

import Foundation

enum GroceryList: Codable, CustomStringConvertible {
    var description: String {
        switch self {
        case .today: "Today"
        case .nextTime: "Next Time"
        case .eventually: "Eventually"
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
}
