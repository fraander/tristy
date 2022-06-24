////
//// ContentView.swift
//// SimpleToDo
////
//// Copyright © 2022 Paul Hudson.
//// Licensed under MIT license.
////
//// https://github.com/twostraws/simple-swiftui
//// See LICENSE for license information
////
//
//import SwiftUI
//
///// A view to let the user edit values inside a `ToDoItem`
//struct ListDetailView: View {
//    /// A live binding to the item we're trying to edit. This comes direct from our view model, so changes
//    /// made here are automatically saved to persistent storage.
//    @Binding var list: TristyList
//    
//    @State var newItemTitle = ""
//    @State var selectedItems = Set<TristyListItem>()
//    @FocusState private var focus: Bool
//    
//    var body: some View {
//        ZStack {
//            List($list.items, edits: [.delete, .move], selection: $selectedItems) { $item in
//                ListItemRowView(item: $item, list: $list, addNewItem: {addNewItem()})
//                    .overlay(selectedItems.contains(item) ? Color(.green) : Color(.clear))
//            }
//#if os(macOS)
//            .listStyle(.inset(alternatesRowBackgrounds: true))
//#endif
//            if (list.items.count == 0) {
//                Text("Use the **Add Bar** below to add items to your list.")
//            }
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle($list.title) {
//            RenameButton()
//            
//            Button {
//                list.items.removeAll()
//            } label: {
//                Label("Clear", systemImage:
//                        "scribble.variable")
//            }
//            
//            Divider()
//            
//            Section {
//                Button {
//                    list.items = list.items.sorted { lhs, rhs in
//                        lhs.title < rhs.title
//                    }
//                } label: {
//                    Label("By Name", systemImage: "a.magnify")
//                }
//                
//                Button {
//                    list.items = list.items.sorted { lhs, rhs in
//                        lhs.dateCreated < rhs.dateCreated
//                    }
//                } label: {
//                    Label("By Date", systemImage: "calendar")
//                }
//                
//                Button {
//                    list.items = list.items.filter { $0.isComplete } + list.items.filter { !$0.isComplete }
//                } label: {
//                    Label("By Status", systemImage: "checkmark.circle.fill")
//                }
//            }
//        }
//        .overlay {
//            VStack {
//                Spacer()
//                
//                ZStack {
//                    HStack {
//                        ZStack(alignment: .leading) {
//                            TextField("", text: $newItemTitle)
//                                .foregroundColor(Color.white)
//                                .accentColor(.white)
//                                .onSubmit {
//                                    if (!newItemTitle.isEmpty) {
//                                        addNewItem(title: newItemTitle)
//                                        newItemTitle = ""
//                                    }
//                                }
//                                .focused($focus)
//                                .task {
//                                    focus = true
//                                }
//                            if newItemTitle.isEmpty {
//                                Text("New item ...")
//                                    .foregroundColor(.white)
//                                    .opacity(0.6)
//                                    .allowsHitTesting(false)
//                            }
//                        }
//                        
//                        Button {
//                            if (!newItemTitle.isEmpty) {
//                                addNewItem(title: newItemTitle)
//                                newItemTitle = ""
//                            }
//                        } label: {
//                            Image(systemName: "plus")
//                                .foregroundColor(.white)
//                        }
//                        
//                    }
//                    .padding(.all)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color.accentColor)
//                            .shadow(radius: 2)
//                    }
//                    .padding(.all)
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItemGroup(placement: ToolbarItemPlacement.primaryAction) {
//                EditButton()
//            }
//        }
//    }
//    
//    func addNewItem(title: String? = nil) {
//        var newItem = TristyListItem()
//        
//        if let title {
//            newItem.title = title
//        }
//        
//        list.items.append(newItem)
//    }
//}
//
//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListDetailView(list: .constant(.example))
//    }
//}
