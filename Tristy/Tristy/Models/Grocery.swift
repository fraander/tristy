//
//  Grocery.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Grocery: Identifiable {
    
    var id: UUID = UUID()
    var title: String = ""
    var completed: Bool = false
    var when: String? = GroceryList.today.description
    var priority: Int = 0
    var pinned: Bool = false
    
    init(title: String, when: GroceryList = .today) {
        self.id = UUID()
        self.title = title
        self.completed = false
        self.when = when.description
        self.priority = 0
        self.pinned = false
    }
}
