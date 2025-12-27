//
//  View+ApplyEnvironment.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData
import OSLog
import FoundationModels

/// Apply the whole collection of Services as a single modifier, instead of duplicating work in both @main and previews.
struct ApplyEnvironmentModifier: ViewModifier {
    
    @State var router = Router()
    @State var abStore = AddBarStore()
    
    /// Should the model container be pre-populated with examples?
    let prePopulate: Bool
    
    var modelContainer: ModelContainer {
        if prePopulate {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(
                for: Grocery.self,
                GroceryStore.self,
                configurations: config
            )
            
            for grocery in Grocery.examples {
                container.mainContext.insert(grocery)
            }
            
            for store in GroceryStore.examples {
                container.mainContext.insert(store)
            }
            
            try! container.mainContext.save()
            
            return container
        } else {
            return try! ModelContainer(for: Grocery.self, GroceryStore.self)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .environment(router)
            .environment(abStore)
            .modelContainer(modelContainer)
    }
}
