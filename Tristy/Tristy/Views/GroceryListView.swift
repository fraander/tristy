//
//  NewGroceryListView.swift
//  Tristy
//
//  Created by Frank Anderson on 11/2/22.
//

import SwiftUI

/// Represents a list of groceries
struct GroceryListView: View {
    
    // MARK: - Enums
    
    enum Focus {
        case addField, none
    }
    
    enum SheetType: Identifiable {
        case groups, tags
        
        var id: Int { self.hashValue }
    }
    
    // MARK: - Instance Variables
    @ObservedObject var repository = GroceryRepository.shared
    @State var sheetType: SheetType? = nil
    @State var text = ""
    @State var tags: [TristyTag] = []
    @FocusState var focusState: Focus?
    @State var showTagsForAdd = false
    
    
    // MARK: - List of Groceries
    var listOfGroceries: some View {
        Group {
            if (GroceryRepository.shared.groceries.isEmpty) {
                emptyListView
            } else {
                populatedListView
            }
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
    
    var populatedListView: some View {
        List {
            ForEach(GroceryRepository.shared.groceries) { grocery in
                GroceryView(groceryVM: .init(grocery: grocery))
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    
    // MARK: - Add Bar
    var addBar: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    List( GroceryRepository.shared.tags.contains {
                        $0.title.contains(text)
                    } ? GroceryRepository.shared.tags.filter { // TODO: replace with better algo that uses # and search indicator
                        $0.title.contains(text)
                    } : GroceryRepository.shared.tags) { tag in
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
                        addGrocery(title: text, incomingTags: tags)
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
                            addGrocery(title: text, incomingTags: tags)
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
    
    var sheets: some View {
        Group {
            if (sheetType == .groups) {
                GroupSettingsView()
            } else if (sheetType == .tags) {
                TagSettingsView()
            }
        }
    }
    
    // MARK: - Toolbar Menu
    var toolbarMenu: some View {
        Group {
            toolbarGroupSection
            
            Divider()
            
            toolbarTagsSection
            
            Divider()
            
            toolbarCheckSection
            
            Divider()
            
            clearAllSection
        }
    }
    
    var toolbarGroupSection: some View {
        Group {
            Text("Group: \(GroupService.shared.groupId)")
            Button {
                sheetType = .groups
            } label: {
                Label("Edit Group", systemImage: "person.2.badge.gearshape.fill")
            }
        }
    }
    
    var toolbarTagsSection: some View {
        Button {
            sheetType = .tags
        } label: {
            Label("Edit Tags", systemImage: "tag.fill")
        }
    }
    
    var toolbarCheckSection: some View {
        let hasOneComplete = GroceryRepository.shared.groceries.contains { $0.completed == true }
        let hasOneIncomplete = GroceryRepository.shared.groceries.contains { $0.completed == false }
        
        let uncheckAll = Button {
            GroceryRepository.shared.groceries.forEach { grocery in
                var newGrocery = grocery
                newGrocery.setCompleted(false)
                
                GroceryRepository.shared.update(newGrocery)
            }
        } label: {
            Label("Uncheck All", systemImage: "xmark")
        }
        
        let checkAll = Button {
            GroceryRepository.shared.groceries.forEach { grocery in
                var newGrocery = grocery
                newGrocery.setCompleted(true)
                
                GroceryRepository.shared.update(newGrocery)
            }
        } label: {
            Label("Complete All", systemImage: "checkmark")
        }
        
        return Group {
            if (hasOneComplete) { uncheckAll }
            if (hasOneIncomplete) { checkAll }
        }
    }
    
    var clearAllSection: some View {
        Group {
            if (!GroceryRepository.shared.groceries.isEmpty) {
                Button(role: .destructive) {
                    GroceryRepository.shared.groceries.forEach { grocery in
                        GroceryRepository.shared.remove(grocery)
                    }
                } label: {
                    Label("Clear All", systemImage: "eraser.line.dashed")
                }
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                listOfGroceries
                addBar
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Groceries")
#if os(macOS)
            .navigationSubtitle(GroupService.shared.groupId)
#endif
            .toolbarTitleMenu {
                toolbarMenu
            }
            .sheet(item: $sheetType) { _ in
                sheets
                    .presentationDetents([.fraction(2/5), .large])
            }
        }
    }
    
    // MARK: - Functions
    private func addGrocery(title: String, incomingTags: [TristyTag]) {
        if (!text.isEmpty) {
            let grocery = TristyGrocery(title: title, tags: incomingTags)
            GroceryRepository.shared.add(grocery)
            text = ""
            tags = []
            withAnimation {
                focusState = GroceryListView.Focus.none
                showTagsForAdd = false
            }
        }
    }
    
    private func deleteItems(items: IndexSet) {
        items.forEach {
            let grocery = GroceryRepository.shared.groceries[$0]
            GroceryRepository.shared.remove(grocery)
        }
    }

}

struct NewGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
    }
}
