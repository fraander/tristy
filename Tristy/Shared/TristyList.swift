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

/// One list.
struct TristyList: Codable, Identifiable, Hashable {
    
    static let example = TristyList(id: UUID(), title: "New list that has a long name")

    /// A unique, random identifier for this list.
    var id = UUID()

    /// The user-facing title of this list.
    var title = "New List"
    
    /// The items in the list
    var items: [TristyListItem] = []

    /// The SF Symbol icon name to use for this list.
    var icon: String {
        if items.count <= 0 {
            return "list.bullet.circle"
        } else {
            return "list.bullet.circle.fill"
        }
    }

    /// The value of the item, to convey this information to assistive technologies.
    var accessibilityValue: String {
        return title
    }
}
