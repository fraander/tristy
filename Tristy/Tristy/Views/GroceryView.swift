//
//  SwiftUIView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI
import SwiftData

struct GroceryView: View {
    enum Focus: Equatable {
        case item, none
        
        static func == (lhs: Focus, rhs: Focus) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
        
    @State var newTitle = ""
    @State var initialValue = ""
    @FocusState var focus: Focus?
    
    @Environment(\.modelContext) var modelContext
    var grocery: Grocery
    
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
                    .opacity(p != .none ? 0.5 : 0)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.easeInOut(duration: 0.15), value: p)
                    .animation(.easeInOut(duration: 0.15), value: p.symbol)                
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
            .focused($focus, equals: .item)
            .font(.system(.body, design: .rounded))
#if os(iOS)
            .scrollDismissesKeyboard(.immediately)
#endif
            
            Text(grocery.title)
                .opacity(0.0)
                .padding(.trailing, 10)
                .lineLimit(1)
                .overlay {
                    strikethroughView
                }
                .animation(.easeOut(duration: 0.25), value: grocery.completed)
            
        }
        .allowsHitTesting(!grocery.completed)
        .foregroundColor(grocery.completed ? .secondary : .primary)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                checkboxView
                
                textView
                
                priorityIndicator
            }
        }
        .font(.system(.body, design: .rounded))
        .task {
            // track value before editing
            initialValue = grocery.title
            newTitle = grocery.title
        }
    }
}
