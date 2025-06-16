//
//  AddBarList.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBarList: View {
    
    @Environment(AddBarStore.self) var abStore
    @Environment(Router.self) var router
    
    @State var groceries = ["Milk", "Bread", "Eggs", "Bananas", "Rice", "Onions", "Tomatoes", "Cheese", "Apples"]
    
    var content: some View {
        ZStack {
            List {
                ForEach(groceries, id: \.self) { grocery in
                    Label(grocery, systemImage: "archivebox")
                        .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .padding(.vertical, 10)
            }
            .frame(minHeight: 60, maxHeight: 180)
            .clipShape(.rect(cornerRadius: Metrics.glassEffectRadius))
            .glassEffect(.regular, in: .rect(cornerRadius: Metrics.glassEffectRadius))
#if os(iOS)
            .scaleEffect(router.isAddBarFocused ? 1 : 0, anchor: .init(x: 0.5, y: 1))
#endif
            .opacity(router.isAddBarFocused ? 1 : 0)
            .allowsHitTesting(router.isAddBarFocused)
            .animation(.easeInOut(duration: Metrics.animationDuration), value: router.isAddBarFocused)
        }
    }
    
    var body: some View {
#if os(iOS)
        content
#else
        Group {
            if router.isAddBarFocused {
                content
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: router.isAddBarFocused)
#endif
    }
}
    
    #Preview {
        @Previewable @State var abs = AddBarStore(query: "Milk")
        
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(
                    Color.cyan.gradient
                )
                .ignoresSafeArea(.all)
            AddBar()
                .environment(AddBarStore(query: "Milk"))
                .environment(Router(focus: .addBar))
                .applyEnvironment()
                .padding()
        }
    }
