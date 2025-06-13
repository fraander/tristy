//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBar: View {
    
    var body: some View {
        VStack {
            AddBarList()
            AddBarTextField()
        }
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
