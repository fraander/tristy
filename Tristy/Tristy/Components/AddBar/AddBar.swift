//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBar: View {
    
    @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
    
    var body: some View {
        VStack {
            if showAddBarSuggestions {
                AddBarList()                
            }
            AddBarTextField()
        }
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
