//
//  GroceryList.swift
//  Tristy
//
//  Created by Frank Anderson on 6/19/25.
//

import SwiftUI

enum GroceryList: Int, RawRepresentable, CaseIterable, Identifiable {
    case active = 0
    case nextTime = 1
    case archive = 2
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .active: "Today"
        case .nextTime: "Next Time"
        case .archive: "Archive"
        }
    }
    
    var symbolName: String {
        switch self {
        case .active: "smallcircle.filled.circle"
        case .nextTime: "arrow.right"
        case .archive: "archivebox"
        }
    }
    
    var color: Color {
        switch self {
        case .active: .accentColor
        case .nextTime: .indigo
        case .archive: .secondary
        }
    }
}

#Preview {
    VStack {
        ForEach(GroceryList.allCases) { gl in
            gl.color
                .overlay {
                    Label(gl.name, systemImage: gl.symbolName)
                        .foregroundStyle(.white)
                }
        }
    }
}
