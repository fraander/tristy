//
//  GroceryTag.swift
//  Tristy
//
//  Created by Frank Anderson on 4/28/24.
//

import Foundation
import SwiftData

@Model
class GroceryTag: Identifiable {
    var id: UUID
    var title: String
    
    init(title: String) {
        self.id = UUID();
        self.title = title
    }
}
