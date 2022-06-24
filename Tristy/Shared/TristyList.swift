//
// ContentView.swift
// SimpleToDo
//
// Copyright © 2022 Paul Hudson.
// Licensed under MIT license.
//
// https://github.com/twostraws/simple-swiftui
// See LICENSE for license information
//

import Foundation
import SwiftUI

extension TristyList {
    //    static let example = TristyListItem(id: UUID(), title: "New list item that has a long name that's annoyingly long", notes: "New list item that has a long name that's annoyingly long's description.", priority: .none, isComplete: false)
    
    var _id: UUID { return id ?? UUID() }
    var _dateCreated: Date { return dateCreated ?? Date() }
    var _title: String { return title ?? "" }
    var _icon: Image {
        let done = _items.reduce(0) {
            $0 + ($1._isComplete ? 1 : 0)
        }
        
        let total = _items.count
        
        if done == total {
            return Image(systemName: "list.bullet.circle.fill")
        } else {
            return Image(systemName: "list.bullet.circle")
        }
    }
    var _order: Int { return Int(order) }
    var _items: [TristyListItem] {
        return items?.sorted(by: {($0 as! TristyListItem)._dateCreated < ($1 as! TristyListItem)._dateCreated}) as! [TristyListItem]
    }
}
