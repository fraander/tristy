//
//  GroceryDraft.swift
//  Tristy
//
//  Created by frank on 4/4/26.
//

import SwiftUI


struct GroceryDraft {
    
    init() {
        self.workingTitle = ""
        self.workingList = .active
        self.workingStore  = nil
        self.workingCompleted = false
        self.workingPinned = false
        self.workingUncertain = false
        self.workingImportance = .none
        self.workingQuantity = .zero
        self.workingUnits = ""
        self.workingNotes = ""
        self.workingCategory = .other
    }
    
    init(from existingGrocery: Grocery) {
            workingTitle = existingGrocery.titleOrEmpty
            workingList = existingGrocery.listEnum
            workingStore = existingGrocery.store
            workingCompleted = existingGrocery.isCompleted
            workingPinned = existingGrocery.isPinned
            workingUncertain = existingGrocery.isUncertain
            workingImportance = existingGrocery.importanceEnum
            workingQuantity = existingGrocery.quantityOrEmpty
            workingUnits = existingGrocery.unitOrEmpty
            workingNotes = AttributedString(existingGrocery.notesOrEmpty)
            workingCategory = existingGrocery.categoryEnum
    }
    
    var hasChangedWorkingTitle: Bool = false
    var hasChangedWorkingList: Bool = false
    var hasChangedWorkingStore: Bool = false
    var hasChangedWorkingCompleted: Bool = false
    var hasChangedWorkingPinned: Bool = false
    var hasChangedWorkingUncertain: Bool = false
    var hasChangedWorkingImportance: Bool = false
    var hasChangedWorkingQuantity: Bool = false
    var hasChangedWorkingUnits: Bool = false
    var hasChangedWorkingNotes: Bool = false
    var hasChangedWorkingCategory: Bool = false
    
    var workingTitle: String = ""
    var workingList: GroceryList = .active
    var workingStore: GroceryStore? = nil
    var workingCompleted: Bool = false
    var workingPinned: Bool = false
    var workingUncertain: Bool = false
    var workingImportance: GroceryImportance = .none
    var workingQuantity: Double = .zero
    var workingUnits: String = ""
    var workingNotes: AttributedString = ""
    var workingCategory: GroceryCategory = .other
}
