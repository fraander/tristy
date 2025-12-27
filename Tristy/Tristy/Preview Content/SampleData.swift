//
//  Sample.swift
//  Tristy
//
//  Created by frank on 12/26/25.
//

import SwiftData
import SwiftUI

struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> Context {
        let config = ModelConfiguration(
            isStoredInMemoryOnly: true,
            cloudKitDatabase: .none
        )
        
        let container = try! ModelContainer(
            for: Grocery.self,
            GroceryStore.self,
            configurations: config
        )
        SampleData.createSampleData(into: container.mainContext)
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content
            .environment(Router())
            .environment(AddBarStore())
            .modelContainer(context)
    }

    static func createSampleData(into modelContext: ModelContext) {
        Task { @MainActor in

            // CREATE

            for grocery in Grocery.examples {
                modelContext.insert(grocery)
            }
            
            for store in GroceryStore.examples {
                modelContext.insert(store)
            }

            // SAVE

            try? modelContext.save()
        }
    }
}

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}

#Preview(traits: .sampleData) {
    ContentView()
}
