//
//  GroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI

// TODO: create focus manager
// TODO: refactor

struct GroceryListView: View {
    
    enum Focus {
        case addField, none
    }
    
    @Environment(\.colorScheme) var colorMode
    @ObservedObject var groceryListVM = GroceryListViewModel()
    @State var text = ""
    @FocusState var focusState: Focus?
    @State var showGroupSettings: Bool = false
    
    var clearAllButton: some View {
        Button(role: .destructive) {
            groceryListVM.groceryVMs.forEach{$0.remove()}
        } label: {
            Label("Clear All", systemImage: "eraser.line.dashed")
        }
    }
    
    var emptyListView: some View {
        GroupBox {
            VStack(spacing: 12) {
                Text("Your list is clear!")
                    .font(.system(.headline, design: .rounded))
                
                Group {
                    Text("Either join a group by typing in your ")
                    + Text("Group ID").bold()
                    + Text(" or use the ")
                    + Text("Add Bar").bold()
                    + Text(" at the bottom of the screen to add some groceries to your list.")
                }
                .font(.system(.caption, design: .rounded))
                .multilineTextAlignment(.center)
                
                Button {
                    showGroupSettings.toggle()
                } label: {
                    Text("Join Group")
                }
                .padding()
                .font(.system(.body, design: .rounded, weight: .medium))
                .buttonStyle(.bordered)
                .tint(.accentColor)
                
            }
            .padding(.horizontal)
        }
        .padding(40)
    }
    
    var listOfGrocery: some View {
        List {
            ForEach(groceryListVM.groceryVMs) { groceryVM in
                GroceryView(groceryVM: groceryVM)
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    var addGroceryButton: some View {
        HStack {
            Button {
                addGrocery(title: text)
            } label: {
                Image(systemName: "plus")
            }
            .tint(focusState == .addField ? Color.accentColor : Color.secondary)
            
            TextField("Add item...", text: $text)
                .focused($focusState, equals: .addField)
                .onSubmit {
                    addGrocery(title: text)
                }
                .submitLabel(.done)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10.0)
                .strokeBorder(Color.secondary, lineWidth: 1)
                .background {
                    RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemBackground))
                }
                .shadow(
                    color: focusState == .addField ? Color.accentColor : Color.clear,
                    radius: focusState == .addField ? 3 : 0
                )
                .animation(Animation.easeInOut(duration: 0.25), value: focusState)
        }
        .padding()
    }
    
    var toolbarMenu: some View {
        Group {
            Text("Group: \(GroupService.shared.groupId)")
            Button {
                showGroupSettings.toggle()
            } label: {
                Label("Edit Group", systemImage: "person.2.badge.gearshape.fill")
            }
            
            Divider()
            
            if (groceryListVM.groceryVMs.contains { $0.grocery.completed == true }) {
                Button {
                    let _ = groceryListVM.groceryVMs.map { groceryVM in
                        groceryVM.grocery.completed = false
                        groceryVM.update(grocery: groceryVM.grocery)
                    }
                } label: {
                    Label("Uncheck All", systemImage: "xmark")
                }
            }
            
            if (groceryListVM.groceryVMs.contains { $0.grocery.completed == false }) {
                Button {
                    let _ = groceryListVM.groceryVMs.map { groceryVM in
                        groceryVM.grocery.completed = true
                        groceryVM.update(grocery: groceryVM.grocery)
                    }
                } label: {
                    Label("Complete All", systemImage: "checkmark")
                }
            }
            
            Divider()
            
            if (!groceryListVM.groceryVMs.isEmpty) {
                clearAllButton                
            }
            
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if (groceryListVM.groceryVMs.isEmpty) {
                    emptyListView
                } else {
                    listOfGrocery
                }
                
                addGroceryButton
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//                    .edgesIgnoringSafeArea(focusState == .addField ? [] : [.all])
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Groceries")
            #if os(macOS)
            .navigationSubtitle(GroupService.shared.groupId)
            #endif
            .toolbarTitleMenu { toolbarMenu }
            .alert("Group ID", isPresented: $showGroupSettings, actions: { GroupSettingsView() },
                   message: { Text("Current Group ID: \(GroupService.shared.groupId)") })
        }
    }
    
    private func deleteItems(items: IndexSet) {
        items.forEach { groceryListVM.groceryVMs[$0].remove() }
    }
    
    private func addGrocery(title: String) {
        if (!text.isEmpty) {
            let grocery = TristyGrocery(title: title)
            groceryListVM.add(grocery)
            text = ""
            focusState = GroceryListView.Focus.none
        }
    }
}

struct GroceryListView_Previews: PreviewProvider {
    static let listOfVM = examples.reduce([GroceryViewModel]()) { partialResult, grocery in
        let groceryVM = GroceryViewModel(grocery: grocery)
        return partialResult + [groceryVM]
    }
    
    static var previews: some View {
        GroceryListView(groceryListVM: GroceryListViewModel(listOfVM))
            .previewDisplayName("Populated list")
        
        GroceryListView(groceryListVM: GroceryListViewModel([]))
            .previewDisplayName("Empty list")
    }
}
