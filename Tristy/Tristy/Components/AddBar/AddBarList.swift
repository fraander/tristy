//
//  AddBarList.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBarList: View {
    
    @Environment(AddBarStore.self) var abStore
    
    @State var groceries = ["Milk", "Bread", "Eggs", "Bananas", "Rice", "Onions", "Tomatoes", "Cheese", "Apples"]
    
    var body: some View {
        ZStack {
            List {
                ForEach(groceries, id: \.self) { grocery in
                    Label(grocery, systemImage: "archivebox")
//                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                        Button("Insert", systemImage: "text.insert") {
//                            withAnimation { groceries.removeAll(where: {$0 == grocery}) }
//                        }
//                            .tint(.accent)
//                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .padding(.vertical, 10)
        }
        .frame(minHeight: 60, maxHeight: 180)
        .clipShape(.rect(cornerRadius: Metrics.glassEffectRadius))
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.glassEffectRadius))
        .scaleEffect(abStore.isAddBarFocused ? 1 : 0, anchor: .init(x: 0.5, y: 1))
        .opacity(abStore.isAddBarFocused ? 1 : 0)
        .allowsHitTesting(abStore.isAddBarFocused)
        .animation(.easeInOut(duration: Metrics.animationDuration), value: abStore.isAddBarFocused)
    }
}

#Preview {
    @Previewable @State var abs = AddBarStore(query: "Milk", focus: .addBar)
    
    ZStack(alignment: .bottom) {
        Rectangle()
            .fill(
                Color.cyan.gradient
            )
            .ignoresSafeArea(.all)
        AddBar()
            .environment(abs)
            .applyEnvironment()
            .padding()
    }
}
