//
//  NewGroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 11/2/22.
//

import SwiftUI
import SwiftData

/// Represents a list of groceries
struct PrimaryView: View {
    
    @State var selectedList: GroceryList = .today
    
    let tabs: [GroceryList] = [.today, .nextTime, .eventually]
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedList) {
                    
                    ForEach(tabs, id: \.description) { tab in
                        GroceryListView(list: tab, listSelection: $selectedList)
                            .tabItem {
                                Label(tab.description, systemImage: tab.symbol)
                            }
                            .tag(tab)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                
                AddBar(list: selectedList)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Picker(selection: $selectedList) {
                        Group {
                            
                            Image(systemName: GroceryList.today.symbol)
                                .tag(GroceryList.today)
                            
                            Image(systemName: GroceryList.nextTime.symbol)
                                .tag(GroceryList.nextTime)
                            
                            Image(systemName: GroceryList.eventually.symbol)
                                .tag(GroceryList.eventually)
                        }
                    } label: {
                        Text("Tab")
                    }
                    .pickerStyle(.palette)
                }
            }
        }
    }
}

struct NewGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(list: .nextTime, listSelection: .constant(.nextTime))
    }
}

