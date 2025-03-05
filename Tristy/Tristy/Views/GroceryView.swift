//
//  SwiftUIView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI
import SwiftData

struct GroceryView: View {
    
    @Environment(\.modelContext) var modelContext
    var grocery: Grocery
    var list: GroceryList
    
    @Binding var setQtyAlertValue: Grocery?
    @Binding var showSetQtyAlert: Bool

    @State var newTitle = ""
    @State var initialValue = ""
    @FocusState var focus: FocusOption?
    
    // button with checkmark to show tag is complete/incomplete
    var checkboxView: some View {
        Button {
            grocery.completed.toggle()
        } label: {
            Image(systemName: "\(grocery.completed ? "checkmark.circle.fill" : "checkmark.circle")")
        }
        .buttonStyle(.plain)
        .foregroundColor(grocery.completed ? .mint : .accentColor)
        .font(.system(.title2))
    }
    
    // line to strikethrough tag title (draw in/out instead of fade with normal .strikethrough() )
    var strikethroughView: some View {
        HStack {
            Capsule()
                .frame(maxWidth: grocery.completed ? .infinity : 0, maxHeight: 2, alignment: .leading)
                .opacity(grocery.completed ? 1 : 0)
            Spacer()
        }
    }
    
    func priorityImageName(_ p: Int) -> String {
        switch p {
        case 1: "exclamationmark"
        case 2: "exclamationmark.2"
        case 3: "exclamationmark.3"
        default: ""
        }
    }
    
    var priorityIndicator: some View {
        Group {
            let p = GroceryPriority.toEnum(grocery.priority)
            if p != .none {
                Image(systemName: p.symbol)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.easeInOut(duration: 0.15), value: p)
                    .animation(.easeInOut(duration: 0.15), value: p.symbol)
                    .foregroundStyle(p == GroceryPriority.low ? Color.indigo.gradient : Color.orange.gradient)
                    .fontWeight(.bold)
            }
        }
    }
    
    var pinnedIndicator: some View {
        Group {
            if grocery.pinned {
                Image(systemName: "pin.fill")
                    .opacity(grocery.pinned ? 1 : 0)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.easeInOut(duration: 0.15), value: grocery.pinned)
                    .foregroundStyle(.red.gradient)
            }
        }
    }
    
    var quantityIndicator: some View {
        Group {
            if (grocery.quantity != 0) {
                Text(grocery.quantity, format: .number)
                    .contentTransition(.numericText())
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .opacity(grocery.quantity == 0 ? 0 : 1)
            }
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
                    initialValue = grocery.title // set new initial value checkpoint
                }
            })
            .lineLimit(1)
            .focused($focus, equals: .listItem)
            .font(.system(.body, design: .rounded))
            
#if os(iOS)
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                if (focus == .listItem) {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Group {
                                ForEach(GroceryList.allCases.filter {grocery.when != $0.description}) { tab in
                                    Button(tab.description, systemImage: tab.symbol) {
                                        grocery.when = tab.description
                                        grocery.pinned = false
                                        grocery.priority = GroceryPriority.none.value
                                    }
                                    .foregroundColor(.cyan)
                                }
                            }
                            Spacer()
                            if (list == .today) {
                                Group {
                                    
                                    Button("Set Quantity", systemImage: "numbers") {
                                        setQtyAlertValue = grocery
                                        showSetQtyAlert = true
                                    }
                                    .foregroundColor(grocery.quantity > 0 ? .cyan : .secondary)
                                    
                                    Button("Pin", systemImage: grocery.pinned ? "pin.fill" : "pin") {
                                        grocery.pinned.toggle()
                                    }
                                    .foregroundColor(grocery.pinned ? .cyan : .secondary)
                                    
                                    Menu("Priority", systemImage: GroceryPriority.toEnum(grocery.priority).symbol) {
                                        ForEach(GroceryPriority.tabs, id: \.self) { tab in
                                            Button(tab.description, systemImage: tab.symbol) {
                                                grocery.priority = tab.value
                                            }
                                        }
                                    }
                                    .foregroundColor(grocery.priority != GroceryPriority.none.value ? .cyan : .secondary)
                                }
                            }
                            Button("Dismiss", systemImage: "keyboard.chevron.compact.down") {
                                focus = nil
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
            }
#endif
            
            Text(grocery.title)
                .opacity(0.0)
                .padding(.trailing, 10)
                .lineLimit(1)
                .overlay {
                    if (grocery.when == GroceryList.today.description) {
                        strikethroughView                        
                    }
                }
                .animation(.easeOut(duration: 0.25), value: grocery.completed)
            
        }
        .allowsHitTesting(!grocery.completed)
        .foregroundColor(grocery.completed ? .secondary : .primary)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                if (grocery.when == GroceryList.today.description) {
                    checkboxView
                }
                
                textView
                
                if (grocery.when == GroceryList.today.description) {

                    quantityIndicator
                    
                    priorityIndicator
                    
                    pinnedIndicator
                    
                }
            }
        }
        #if os(macOS)
        .padding(.vertical, 2)
        #endif
        .font(.system(.body, design: .rounded))
        .task {
            // track value before editing
            initialValue = grocery.title
            newTitle = grocery.title
        }
    }
}
