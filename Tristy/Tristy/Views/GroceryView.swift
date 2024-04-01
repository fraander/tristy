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
    @State var toDeleteTag: TristyTag?
    
    @Environment(\.modelContext) var modelContext
    var grocery: TristyGrocery
    
    // horizontal list of tags
    var tagsView: some View {
        Group {
            if !((grocery.tags?.isEmpty) != nil) && !grocery.completed {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(grocery.tags ?? [], id: \.title) { tag in
                            Button {
                                toDeleteTag = tag
                            } label: {
                                Text(tag.title.lowercased())
                                    .font(.system(.caption, design: .rounded))
                            }
                            .buttonStyle(.bordered)
                            .tint(.accentColor)
                            .transition(.scale.combined(with: .slide))
                        }
                    }
                    .animation(.spring(), value: grocery.tags)
                }
                .scrollIndicators(.never)
                .transition(.slide.combined(with: .opacity))
                .animation(Animation.easeInOut, value: grocery.completed)
            }
        }
    }
    
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
            .focused($focus, equals: .item)
#if os(iOS)
            .scrollDismissesKeyboard(.immediately)
#endif
            
            Text(grocery.title)
                .opacity(0.0)
                .padding(.trailing, 10)
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
            }
            
            tagsView
        }
        .font(.system(.body, design: .rounded))
        .task {
            // track value before editing
            initialValue = grocery.title
            newTitle = grocery.title
        }
        .alert(item: $toDeleteTag) { tag in
            if let t = toDeleteTag {
                return Alert(
                    title: Text("Are you sure you want to remove \(tag.title) from this item?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Remove")) {
                        modelContext.delete(t)
                    }
                )
            } else {
                return Alert(title: Text("Error removing tag from grocery."))
            }
        }
    }
}
