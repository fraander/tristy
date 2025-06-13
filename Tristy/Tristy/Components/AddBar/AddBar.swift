//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBar: View {
    
    @Environment(AddBarStore.self) var abStore
    
    var body: some View {
        VStack {
            if abStore.isFocused {
                AddBarList()
                    .transition(.scale(scale: 0, anchor: .init(x: 0.5, y: 1)).combined(with: .opacity))
            }
            
            AddBarTextField()
        }
        .animation(.easeInOut, value: abStore.isFocused)
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
