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
    
    var contentBody: some View {
        ForEach(GroceryList.tabs, id: \.description) { tab in
            GroceryListView(list: tab, listSelection: $selectedList)
                .tabItem {
                    Label(tab.description, systemImage: tab.symbol)
                }
                .tag(tab)
        }
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            
            
#if os(iOS)
            NavigationStack {
                ZStack {
                    TabView(selection: $selectedList) {
                        contentBody
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }
                
                AddBar(list: selectedList)
            }
#else
            ZStack(alignment: .bottom) {
                GroceryListView(list: selectedList, listSelection: $selectedList)
                    .animation(.easeInOut(duration: 0.15), value: selectedList)
                AddBar(list: selectedList)
            }
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        Picker("list", selection: $selectedList) {
                            
                            ForEach(GroceryList.tabs, id: \.description) { tab in
                                Label(tab.description, systemImage: tab.symbol)
                                    .tag(tab)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
#endif
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                HStack {
                    Image(systemName: selectedList.symbol)
                        .foregroundColor(.accentColor)
                    Text(selectedList.description)
                }
                .font(.system(.headline, design: .rounded, weight: .medium))
            }
            
        }

    }
}

struct NewGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(list: .nextTime, listSelection: .constant(.nextTime))
    }
}

