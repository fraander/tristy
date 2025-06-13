//
//  Router.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Observation
import SwiftUI

@Observable
class Router {
    init(tab: TristyTab = .today, sheet: TristySheet? = nil) {
        self.tab = tab
        self.sheet = sheet
    }
    
    // MARK: TAB -
    private(set) var tab: TristyTab = .today
    var tabBinding: Binding<TristyTab> {
        .init(
            get: { self.tab },
            set: { self.tab = $0 }
        )
    }
    
    func setTab(to tab: TristyTab) {
        self.tab = tab
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
}
