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
    
    @State var newItemTitle = ""
    
    @State var selectedItems = Set<TristyListItem>()
    
    var body: some View {
        
        List(selection: $selectedItems) {
            if ($list.items.count == 0) {
                Text("Use the Add Bar at the bottom of the screen to add items")
                    .padding(20)
            }
            
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
        .toolbar {
            ToolbarItem {
                Button("Rename List") {
                    // do something ... // TODO:
                }
            }
        }
        .overlay {
            VStack {
                Spacer()
                
                ZStack {
                    HStack {
                        ZStack(alignment: .leading) {
                            TextField("", text: $newItemTitle)
                                .foregroundColor(Color.white)
                                .accentColor(.white)
                                .onSubmit {
                                    if (!newItemTitle.isEmpty) {
                                        addNewItem(title: newItemTitle)
                                        newItemTitle = ""
                                    }
                                }
                            if newItemTitle.isEmpty {
                                Text("New item ...")
                                    .foregroundColor(.white)
                                    .opacity(0.6)
                                    .allowsHitTesting(false)
                            }
                        }
                        
                        Button {
                            if (!newItemTitle.isEmpty) {
                                addNewItem(title: newItemTitle)
                                newItemTitle = ""
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }

                    }
                        .padding(.all)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                                .shadow(radius: 2)
                        }
                        .padding(.all)
                }
            }
        }
    }
    
    func addNewItem(title: String? = nil) {
        var newItem = TristyListItem()
        
        if let title {
            newItem.title = title
        }
        
        list.items.append(newItem)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView(list: .constant(.example))
    }
}
