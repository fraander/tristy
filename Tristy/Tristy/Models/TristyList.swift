//
//  TristyList.swift
//  Tristy
//
//  Created by Frank Anderson on 4/1/24.
//

import Foundation
import SwiftData

@Model
class TristyList: Identifiable {
    var id: UUID
    var groceries: [TristyGrocery]?
    
    init(id: UUID = UUID(), groceries: [TristyGrocery]? = nil) {
        self.id = id
        self.groceries = groceries
    }
}
