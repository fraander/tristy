//  TextEditView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI

struct TextEditView: View {
    @Binding var newTitle: String
    @Binding var initialValue: String
    @Bindable var grocery: Grocery
    @FocusState var focus: FocusOption?
    
    var body: some View {
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
            .font(.system(.body, design: .rounded))
            
            Text(newTitle)
                .opacity(0.0)
                .padding(.trailing, 10)
                .lineLimit(1)
                .overlay { StrikethroughView(isCompleted: grocery.isCompleted) }
                .animation(.easeOut(duration: 0.25), value: grocery.isCompleted)
        }
        .foregroundColor(grocery.isCompleted ? .secondary : .primary)
    }
}
