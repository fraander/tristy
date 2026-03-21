//
//  Router.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Observation
import SwiftUI
import SwiftData

@Observable
class Router {
    init(
        sheet: TristySheet? = nil,
    ) {
        self.sheet = sheet
    }
    
    // MARK: SHEET -
    private(set) var sheet: TristySheet? = nil
    var sheetBinding: Binding<Bool> {
        .init(
            get: { self.sheet != nil },
            set: { newValue in
                if !newValue {
                    self.sheet = nil
                }
            }
        )
    }
    
    func presentSheet(_ sheet: TristySheet) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    // MARK: - Selected groceries
    var selectedGroceries: Set<PersistentIdentifier> = []
    var selectedGroceriesBinding: Binding<Set<PersistentIdentifier>> {
        .init(
            get: { self.selectedGroceries },
            set: { self.selectedGroceries = $0 }
        )
    }
}
