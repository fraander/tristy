//
//  AddBarList.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBarList: View {
    
    @Environment(AddBarStore.self) var abStore
    
    var body: some View {
        ZStack {
            List {
                ForEach(0..<10, id: \.self) { i in
                    Text("Row \(i)")
                        .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.inset)
        }
        .frame(minHeight: 120, maxHeight: 240)
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.glassEffectRadius))
    }
}

#Preview {
    @Previewable @State var abs = AddBarStore(query: "Milk", isFocused: true)
    
    AddBar()
        .environment(abs)
        .applyEnvironment()
}
