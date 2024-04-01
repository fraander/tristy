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
class TristyGrocery: Identifiable {
    var id: UUID
    var title: String
    var completed: Bool = false
    var tags: [TristyTag]?
    var lists: [TristyList]?
    
    init(title: String, tags: [TristyTag]) {
        self.id = UUID()
        self.title = title
        self.tags = tags
        self.completed = false
    }
}
