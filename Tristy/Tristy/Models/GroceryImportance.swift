//
//  GroceryImportance.swift
//  Tristy
//
//  Created by Frank Anderson on 6/19/25.
//

import SwiftUI

enum GroceryImportance: Int, RawRepresentable, Identifiable, CaseIterable {
    case none = 0
    case somewhat = 1
    case very = 2
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .none: "None"
        case .somewhat: "Somewhat"
        case .very: "Very"
        }
    }
    
    var color: Color {
        switch self {
        case .none: .secondary
        case .somewhat: .orange.mix(with: .yellow, by: 0.5)
        case .very: .orange.mix(with: .red, by: 0.5)
        }
    }
    
    var symbolName: String {
        switch self {
        case .none: "circle.slash"
        case .somewhat: "exclamationmark"
        case .very: "exclamationmark.2"
        }
    }
}

#Preview {
    VStack {
        ForEach(GroceryImportance.allCases) { gl in
            gl.color
                .overlay {
                    Label(gl.name, systemImage: gl.symbolName)
                        .foregroundStyle(.white)
                }
        }
    }
}
