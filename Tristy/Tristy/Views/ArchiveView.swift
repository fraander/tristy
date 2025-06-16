//
//  ArchiveView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct ArchiveView: View {
    
    var contents: some View {
        List {
            GroceryListSection(list: .archive, isExpanded: true)
                .listSectionMargins(.bottom, 120)
        }
        .scrollContentBackground(.hidden)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .secondary)
                
                contents
            }
            .navigationTitle("Archive")
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .archive))
        .applyEnvironment()
}
