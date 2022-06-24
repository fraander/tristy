//
//  TristyListItem.swift
//  Tristy
//
//  Created by Frank Anderson on 5/15/22.
//

import Foundation

enum TristyPriority {
    case high, medium, low, none
}

extension TristyListItem {
    var _title: String { title ?? "" }
    var _priority: TristyPriority {
        switch priority {
            case "high":
                return TristyPriority.high
            case "medium":
                return TristyPriority.medium
            case "low":
                return TristyPriority.low
            default:
                return TristyPriority.none
        }
    }
    var _order: Int { Int(order) }
    var _notes: String { notes ?? "" }
    var _isComplete: Bool { isComplete == 1.0 ? true : false }
    var _id: UUID { id ?? UUID() }
    var _dateCreated: Date { dateCreated ?? Date() }
    var _list: TristyList? { list }
}
