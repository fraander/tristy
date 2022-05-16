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
    
    @Binding var selectedItems: Set<AnyHashable>
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Title", text: $list.title)
                        .font(Font.system(.largeTitle, design: .rounded).bold())
                        .textFieldStyle(.plain)
                }
            }
            
            Section {
                List(/*selection: $selectedItems*/) {
                    ForEach($list.items) { $item in
                        ListItemRowView(item: $item, list: $list, addNewItem: {addNewItem()})
                    }
                }
            }
        }
        .navigationTitle(list.title)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
    
    func addNewItem() {
        let newItem = TristyListItem()
        list.items.append(newItem)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView(list: .constant(.example), selectedItems: .constant(Set()))
    }
}
