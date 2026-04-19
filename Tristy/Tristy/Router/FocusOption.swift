//
//  FocusOption.swift
//  Tristy
//
//  Created by Frank Anderson on 6/15/25.
//

import SwiftUI
import SwiftData

enum FocusOption: Identifiable, Equatable, Hashable {
    case addBar
    case grocery(PersistentIdentifier)
    
    var id: String {
        switch self {
        case .addBar:
            "addBar"
        case .grocery(let id):
            "grocery - \(id.storeIdentifier ?? "ERROR")"
        }
    }
}
