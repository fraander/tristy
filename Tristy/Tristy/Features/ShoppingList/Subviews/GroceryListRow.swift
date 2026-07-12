//
//  GroceryView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Foundation
import SwiftUI
import SwiftData

struct GroceryListRow: View {
    
    @Environment(\.groceryList) var list
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    @Bindable var grocery: Grocery
    
    @State var newTitle = ""
    @State var initialValue = ""
    
    @FocusState var focus: FocusOption?
    
    @Namespace var namespace
    @State var showInfo = false
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Group {
                    if list == .active {
                        HStack {
                            CheckboxView(grocery: grocery)
                            TextEditView(newTitle: $newTitle, initialValue: $initialValue, grocery: grocery, focus: _focus)
                        }
                    } else {
                        Text(grocery.titleOrEmpty)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                GroceryListRowIcons(grocery: grocery)
            }
        }
        .sheet(isPresented: $showInfo) {
            Group {
                if router.selectedGroceries.count <= 1 {
                    GroceryDetailView(type: .single(grocery))
                } else {
                    let r = router.selectedGroceries
                    let predicate = #Predicate<Grocery> { grocery in
                        r.contains(grocery.persistentModelID)
                    }
                    let items = (try? modelContext.fetch(FetchDescriptor<Grocery>(predicate: predicate))) ?? []
                    
                    GroceryDetailView(type: .bulk(items))
                }
            }
#if os(iOS)
                .navigationTransition(.zoom(sourceID: "info_\(grocery.persistentModelID)", in: namespace))
            #endif
        }
        .frame(minHeight: 24)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            GroceryListButtonsView()
                .labelStyle(.iconOnly)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            InfoButtonView(showInfo: $showInfo, grocery: grocery, namespace: namespace)
                .labelStyle(.iconOnly)
        }
        .contextMenu {
            Section { GroceryListButtonsView() }
            Section { InfoButtonView(showInfo: $showInfo, grocery: grocery, namespace: namespace) }
        }
        .font(.system(.body, design: .rounded))
        .task {
            // track value before editing
            initialValue = grocery.titleOrEmpty
            newTitle = grocery.titleOrEmpty
        }
        .onChange(of: grocery.titleOrEmpty) { oldValue, newValue in
            initialValue = grocery.titleOrEmpty
            newTitle = grocery.titleOrEmpty
        }
    }
}
