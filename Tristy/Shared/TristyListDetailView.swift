//
// ContentView.swift
// SimpleToDo
//
// Copyright © 2022 Paul Hudson.
// Licensed under MIT license.
//
// https://github.com/twostraws/simple-swiftui
// See LICENSE for license information
//

import SwiftUI

/// A view to let the user edit values inside a `ToDoItem`
struct ListDetailView: View {
    /// A live binding to the item we're trying to edit. This comes direct from our view model, so changes
    /// made here are automatically saved to persistent storage.
    @Binding var list: TristyList
    
    @State var selectedItems = Set<TristyListItem>()
    
    var body: some View {
        
        VStack {
            ForEach(Array(selectedItems)) { item in
                Text(item.title)
            }
        }
        
        List(selection: $selectedItems) {
            ForEach($list.items) { $item in
                ListItemRowView(item: $item, list: $list, addNewItem: {addNewItem()})
                    .overlay(selectedItems.contains(item) ? Color(.green) : Color(.clear))
            }
            .onDelete {indexSet in
                indexSet.forEach({list.items.remove(at: $0)})
            }
            .onMove(perform: { indices, newOffset in
                withAnimation {
                    list.items.move(fromOffsets: indices, toOffset: newOffset)
                    // TODO: the hack with the last item being empty doesn't work anymore. Find a new way to do this (if after forEach)
                }
            })
        }
#if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
#endif
        //        }
        .navigationTitle(list.title)
    }
    
    func addNewItem() {
        let newItem = TristyListItem()
        list.items.append(newItem)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView(list: .constant(.example))
    }
}
