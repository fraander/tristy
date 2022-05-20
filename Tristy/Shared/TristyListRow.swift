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

/// Displays a single item from the list in `ContentView`.
struct TristyListRow: View {
    
    /// A live binding to the item we're trying to show. This comes direct from our view model.
    @Binding var list: TristyList
    @State var editing = false
    
    @Binding var selectedItems: Set<TristyList>
    
    var deleteList: (TristyList) -> ()

    var body: some View {
        NavigationLink {
            ListDetailView(list: $list)
        } label: {
            Label(list.title, systemImage: list.icon)
                .animation(nil, value: list)
        }
        .popover(isPresented: $editing) {
            EditListTitleView(title: $list.title, editing: $editing)
        }
        .tag(list)
        .accessibilityValue(list.accessibilityValue)
        .contextMenu {
            Button("Rename List") {
                editing.toggle()
            }
            
            Button(role: .destructive) {
                deleteList(list)
            } label: {
                Label("Delete List", systemImage: "trash")
            }
            
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TristyListRow(list: .constant(.example), selectedItems: .constant(Set()), deleteList: {_ in })
    }
}
