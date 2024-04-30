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
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedList) {
                    
                    ForEach(GroceryList.tabs, id: \.description) { tab in
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
        }
    }
}

struct NewGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(list: .nextTime, listSelection: .constant(.nextTime))
    }
}

