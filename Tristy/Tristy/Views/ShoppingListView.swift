//
//  ShoppingListView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI
import SwiftData

struct FilteredGroceryQuery: View {
    @Environment(\.modelContext) var modelContext
    @Query var groceries: [Grocery]
    
    init(filter: Predicate<Grocery>, sort: [SortDescriptor<Grocery>] = []) {
        self._groceries = Query(filter: filter, sort: sort, animation: .default) // Expected declaration; Expected expression in assignment
    }
    
    init(list: GroceryList) {
        let intValue = list.rawValue
        self.init(filter: #Predicate { $0.list == intValue })
    }
    
    var body: some View {
        Group {
            ForEach(groceries) { grocery in
                GroceryListRow(grocery: grocery)
            }
            
//            if groceries.isEmpty {
//                 // TODO: some explanation of what to do about it being empty
//            }
        }
    }
}

struct ListSection: View {
    
    var list: GroceryList
    @State var isExpanded = true
    
    var body: some View {
        
        Section(isExpanded: $isExpanded) {
            FilteredGroceryQuery(list: list)
        } header: {
            Text(list.name)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()                
                    }
                }
        }
    }
}

struct ShoppingListView: View {
    
    @Environment(Router.self) var router
    
    var contents: some View {
        List {
            ListSection(list: .active, isExpanded: true)
            ListSection(list: .nextTime, isExpanded: false)
                .listSectionMargins(.bottom, 120)
        }
        .scrollContentBackground(.hidden)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .accent)
                
                contents
            }
            .navigationTitle(TristyTab.today.rawValue)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Filter", systemImage: Symbols.filter) {}
//                    Button("Show only completed", systemImage: "checkmark.circle.fill") {}
                    Menu("More", systemImage: Symbols.more) {
                        Button("More 1") {}
                        Button("More 2") {}
                        Button("More 3") {}
                    }
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") { router.presentSheet(.settings) }
                    
                    Settings.AddBarSuggestions().control
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.init(tab: .today))
        .applyEnvironment()
}
