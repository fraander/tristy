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
                    
                
                    AddBar(list: selectedList)
                }
            }
#else
            ZStack(alignment: .bottom) {
                GroceryListView(list: selectedList, listSelection: $selectedList)
                    .animation(.easeInOut(duration: 0.15), value: selectedList)
                AddBar(list: selectedList)
                Group {
                    Button(GroceryList.today.description) {
                        selectedList = .today
                    }
                    .keyboardShortcut("1", modifiers: .command)
                    
                    Button(GroceryList.nextTime.description) {
                        selectedList = .nextTime
                    }
                    .keyboardShortcut("2", modifiers: .command)
                    
                    Button(GroceryList.eventually.description) {
                        selectedList = .eventually
                    }
                    .keyboardShortcut("3", modifiers: .command)
                    
                }
                .opacity(0)
                .allowsHitTesting(false)
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
#if os(macOS)
        .navigationTitle(selectedList.description)
#endif
    }
}

struct NewGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView(list: .eventually, listSelection: .constant(.eventually))
    }
}

