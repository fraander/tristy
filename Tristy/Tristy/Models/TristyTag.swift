//
//  TristyTag.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import Foundation
import SwiftData

@Model
class TristyTag {
    var id: UUID
    var title: String
    var groceries: [TristyGrocery]?
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
