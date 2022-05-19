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

enum EditModeCustom {
    case inactive, active, transient
}

/// The main listing view for the app, showing all to do items for the user to select from.
struct ContentView: View {
    /// The shared view model.
    @ObservedObject var model: ViewModel
    
    /// All the items that are currently selected in the list.
    @State private var selectedList = Set<TristyList>()
    
#if os(iOS)
    /// Whether editing is currently active or not. We use this rather than the
    /// Environment edit mode because it creates simpler code.
    @State private var editMode = EditMode.inactive
#elseif os(macOS)
    @State private var editMode = EditModeCustom.inactive
#endif
    
    var body: some View {
        List(selection: $selectedList) {
            ForEach($model.items) { $list in
                TristyListRow(list: $list, selectedItems: $selectedList)
                    .contextMenu {
                        Button(role: .destructive) {
                            model.items.removeAll { list.id == $0.id }
                            model.save()
                        } label: {
                            Label("Delete List", systemImage: "trash")
                        }

                    }
            }
            .onDelete(perform: model.delete)
            .onMove(perform: { indices, newOffset in
                withAnimation {
                    model.items.move(fromOffsets: indices, toOffset: newOffset)
                }
            })
        }
        .listStyle(.sidebar)
        .navigationTitle("Tristy")
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: model.add) {
                    Label("Add List", systemImage: "plus")
                }
            }
#elseif os(macOS)
            Button {
                model.add()
            } label: {
                Label("New List", systemImage: "text.badge.plus")
            }
#endif
        }
        .font(.system(.body, design: .rounded))
        .animation(.default, value: model.items)
        .listStyle(.sidebar)
#if os(iOS)
        .environment(\.editMode, $editMode)
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ViewModel())
    }
}
