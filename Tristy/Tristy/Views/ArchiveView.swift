//
//  ArchiveView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    
    @State var selectedGroceries: Set<PersistentIdentifier> = []
    
    var contents: some View {
        List {
            GroceryListSection(list: .archive, isExpanded: true, selectedGroceries: $selectedGroceries)
            #if os(iOS)
                .listSectionMargins(.bottom, 120)
            #endif
        }
        .scrollContentBackground(.hidden)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                #if os(iOS)
                BackgroundView(color: .secondary)
                #endif
                
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
