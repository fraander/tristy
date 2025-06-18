//
//  AddBarList.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData
import CoreSpotlight

struct AddBarList: View {
    
    @Environment(AddBarStore.self) var abStore
    @Environment(Router.self) var router
    
    struct AddBarListQuery: View {
        @Environment(\.modelContext) var modelContext
        @Query var groceries: [Grocery]
        @Binding var query: String
        
        @State var filtered: [Grocery] = []
        
        var body: some View {
            Group {
                ForEach(filtered, id: \.self) { grocery in
                    Button {
                        withAnimation {
                            query = ""
                            grocery.setList(.active)
                            filtered.removeAll { $0.id == grocery.id }
                        }
                    } label: {
                        HStack {
                            Label(grocery.titleOrEmpty, systemImage: grocery.listEnum.symbolName)
                                .labelStyle(.tintedIcon(icon: grocery.listEnum.color))
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.top, grocery == filtered.first ? 15 : 0)
                        .padding(.bottom, grocery == filtered.last ? 15 : 0)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }

                    if grocery != filtered.last {
                        Divider()
                    }
                }
            }
            .onChange(of: query) {
                withAnimation {
                    filtered = findClosestGroceries(for: query, in: groceries)
                }
            }
        }
        
        func findClosestGroceries(for title: String, in groceries: [Grocery], limit: Int = 6) -> [Grocery] {
            let searchTitle = title.lowercased()
            
            return groceries
                .compactMap { grocery -> (Grocery, Int)? in
                    let groceryTitle = grocery.titleOrEmpty.lowercased()
                    guard !groceryTitle.isEmpty else { return nil }
                    
                    var score = 0
                    if groceryTitle == searchTitle { score = 100 }
                    else if groceryTitle.hasPrefix(searchTitle) { score = 80 }
                    else if searchTitle.hasPrefix(groceryTitle) { score = 70 }
                    else if groceryTitle.contains(searchTitle) { score = 60 }
                    else if searchTitle.contains(groceryTitle) { score = 50 }
                    else { return nil }
                    
                    return (grocery, score)
                }
                .sorted { $0.1 > $1.1 }
                .prefix(limit)
                .map { $0.0 }
        }
    }
    
    @State var queryHeight: CGFloat = .zero
    
    var content: some View {
        
        let showCondition = !abStore.queryIsEmpty && router.isAddBarFocused
        
        return ScrollView(.vertical) {
            VStack {
                AddBarListQuery(query: abStore.queryBinding)
            }
            .readSize { size in
                withAnimation {
                    queryHeight = size.height
                }
            }
        }
        .scrollDismissesKeyboard(.never)
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxWidth: .infinity, maxHeight: min(180, queryHeight))
        .clipShape(.rect(cornerRadius: Metrics.glassEffectRadius))
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.glassEffectRadius))
//#if os(iOS)
//        .scaleEffect(showCondition ? 1 : 0, anchor: .init(x: 0.5, y: 1))
//#endif
        .opacity(showCondition ? 1 : 0)
        .allowsHitTesting(showCondition)
        .animation(.easeInOut(duration: Metrics.animationDuration), value: showCondition)
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
