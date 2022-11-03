//
//  SwiftUIView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI

struct GroceryView: View {
    enum Focus: Equatable {
        case item, none
        
        static func == (lhs: Focus, rhs: Focus) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    let grocery: TristyGrocery
    @State var title = ""
    @State var initialValue = ""
    @FocusState var focus: Focus?
    
    var body: some View {
        HStack {
            Button {
                var newGrocery = grocery
                newGrocery.setCompleted()
                GroceryRepository.shared.update(newGrocery)
            } label: {
                Image(systemName: "\(grocery.completed ? "checkmark.circle.fill" : "checkmark.circle")")
            }
            .buttonStyle(.plain)
            .foregroundColor(grocery.completed ? .mint : .accentColor)
            .font(.system(.title2))
            
            ZStack(alignment: .leading) {
                TextField("", text: $title, onEditingChanged: { _ in
                    if title.isEmpty { // check not left empty
                        initialValue = grocery.title
                    } else { // update
                        var newGrocery = grocery
                        newGrocery.setTitle(title)
                        GroceryRepository.shared.update(newGrocery)
                    }
                    
                }, onCommit: {
                    if grocery.title.isEmpty {
                        title = initialValue
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
                        HStack {
                            Capsule()
                                .frame(maxWidth: grocery.completed ? .infinity : 0, maxHeight: 2, alignment: .leading)
                                .opacity(grocery.completed ? 1 : 0)
                            Spacer()
                        }
                    }
                    .animation(.easeOut(duration: 0.25), value: grocery.completed)
                
            }
            .allowsHitTesting(!grocery.completed)
            .foregroundColor(grocery.completed ? .secondary : .primary)
        }
        .font(.system(.body, design: .rounded))
        .task {
            initialValue = grocery.title
            title = grocery.title
        }
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = examples[0]
        return GroceryView(grocery: grocery)
    }
}
