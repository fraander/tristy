//
//  GroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI

// TODO: create focus manager
// TODO: refactor
// TODO: add search for tags, and way to create new one if the one they want isn't there

struct GroceryListView: View {
    
    enum Focus {
        case addField, none
    }
    
    enum SheetType: Identifiable {
        case groups, tags
        
        var id: Int { self.hashValue }
    }
    
    @Environment(\.colorScheme) var colorMode
    @ObservedObject var groceryListVM = GroceryListViewModel()
    @State var text = ""
    @State var tags: [TristyTag] = []
    @FocusState var focusState: Focus?
    @State var sheetType: SheetType? = nil
    @State var showTagsForAdd = false
    
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
                    sheetType = .groups
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
        GeometryReader { geo in
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    List(groceryListVM.groceryRepository.tags) { tag in
                        Button {
                            if (tags.contains {
                                tag.id == $0.id
                            }) {
                                tags.removeAll {
                                    tag.id == $0.id
                                }
                            } else {
                                tags.append(tag)
                            }
                        } label: {
                            HStack {
                                Text(tag.title)
                                    .fixedSize()
                                
                                Spacer()
                                
                                if (tags.contains { tag.id == $0.id }) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    if (!tags.isEmpty) {
                        Divider()
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(tags) { tag in
                                    Button {
                                        tags.removeAll { $0.id == tag.id }
                                    } label: {
                                        Text(tag.title.lowercased())
                                            .font(.system(.caption, design: .rounded))
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.accentColor)
                                }
                            }
                            .padding(8)
                        }
                        .background {
                            Rectangle()
                                .fill(.background)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .frame(maxWidth: .infinity, maxHeight: showTagsForAdd ? .infinity : 0, alignment: .bottom)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(Color.secondary, lineWidth: 1)
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemBackground))
                        }
                        .shadow(
                            color: focusState == .addField ? Color.secondary : Color.clear,
                            radius: focusState == .addField ? 3 : 0
                        )
                        .animation(Animation.easeInOut(duration: 0.25), value: focusState)
                }
                .frame(height: geo.size.height * 0.4)
                .opacity(showTagsForAdd ? 1 : 0)
                .animation(.default, value: showTagsForAdd)
                
                HStack {
                    Button {
                        addGrocery(title: text)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(focusState == .addField ? Color.accentColor : Color.secondary)
                    
                    TextField("Add item...", text: $text)
                        .focused($focusState, equals: .addField)
                        .onChange(of: focusState) { _ in
                            if (focusState == nil) {
                                showTagsForAdd = false
                            }
                        }
                        .onSubmit {
                            addGrocery(title: text)
                            tags = []
                            showTagsForAdd = false
                        }
                        .submitLabel(.done)
                    
                    Button {
                        focusState = .addField
                        withAnimation {
                            showTagsForAdd.toggle()
                        }
                    } label: {
                        Image(systemName: "\(showTagsForAdd ? "tag.fill" : "tag")")
                    }
                    .tint(focusState == .addField ? Color.accentColor : Color.secondary)
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
            }
        }
        .padding()
    }
    
    var toolbarMenu: some View {
        Group {
            Text("Group: \(GroupService.shared.groupId)")
            Button {
                sheetType = .groups
            } label: {
                Label("Edit Group", systemImage: "person.2.badge.gearshape.fill")
            }
            
            Divider()
            
            Button {
                sheetType = .tags
            } label: {
                Label("Edit Tags", systemImage: "tag.fill")
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
            .sheet(item: $sheetType) { st in
                Group {
                    if (st == .groups) {
                        GroupSettingsView()
                    } else if (st == .tags) {
                        TagSettingsView(groceryRepository: groceryListVM.groceryRepository)
                    }
                }
                .presentationDetents([.fraction(2/5), .large])
            }
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
            tags = []
            withAnimation {
                focusState = GroceryListView.Focus.none
                showTagsForAdd = false
            }
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
