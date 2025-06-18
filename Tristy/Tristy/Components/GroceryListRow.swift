//
//  GroceryView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//


import SwiftUI
import SwiftData

struct GroceryListRow: View {
    
    @Environment(\.groceryList) var list
    @Environment(\.selectedGroceries) var selectedGroceries
    @Environment(\.modelContext) var modelContext
    @Environment(AddBarStore.self) var abStore
    @Environment(Router.self) var router
    var grocery: Grocery
    
    @State var newTitle = ""
    @State var initialValue = ""
    
    @FocusState var focus: FocusOption?
    
    // button with checkmark to show tag is complete/incomplete
    var checkboxView: some View {
        Button(
            "Complete grocery",
            systemImage: "\(grocery.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")",
            action: {
                grocery.toggleCompleted()
            }
        )
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .foregroundColor(grocery.isCompleted ? .mint : .accentColor)
        .animation(.easeOut(duration: 0.25), value: grocery.completed)
        .font(.system(.title2))
    }
    
    // line to strikethrough tag title (draw in/out instead of fade with normal .strikethrough() )
    var strikethroughView: some View {
        HStack {
            Capsule()
                .frame(maxWidth: grocery.isCompleted ? .infinity : 0, maxHeight: 2, alignment: .leading)
                .opacity(grocery.isCompleted ? 1 : 0)
            Spacer()
        }
    }
    
    // show text or textfield depending on completion state
    var textView: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $newTitle, onEditingChanged: { _ in
                if (newTitle.isEmpty) { // check not left empty
                    newTitle = initialValue // reset to initial value so not blank
                } else { // update
                    grocery.title = newTitle // set the title
                    initialValue = grocery.titleOrEmpty // set new initial value checkpoint
                }
            })
            .lineLimit(1)
            .focused($focus, equals: .grocery(grocery.id))
            .onChange(of: focus, { oldValue, newValue in
                router.updateFocus(from: oldValue, to: newValue, for: .grocery(grocery.id))
            })
            .onChange(of: router.focus, { focus = $1 })
            .font(.system(.body, design: .rounded))
            
            Text(newTitle)
                .opacity(0.0)
                .padding(.trailing, 10)
                .lineLimit(1)
                .overlay { strikethroughView }
                .animation(.easeOut(duration: 0.25), value: grocery.completed)
            
        }
        .foregroundColor(grocery.isCompleted ? .secondary : .primary)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if list == .active {
                HStack {
                    checkboxView
                    textView
                }
            } else {
                Text(grocery.titleOrEmpty)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            ForEach(GroceryList.allCases) { gl in
                if list != gl {
                    Button(gl.name, systemImage: gl.symbolName) {
                        grocery.setList(gl)
                    }
                    .tint(gl.color)
                }
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button("Info", systemImage: Symbols.info) {
                router.presentSheet(TristySheet.groceryInfo(grocery))
            }
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
