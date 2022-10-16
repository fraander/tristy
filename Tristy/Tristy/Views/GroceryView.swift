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
    
    @ObservedObject var groceryVM: GroceryViewModel
    @State var initialValue = ""
    @FocusState var focus: Focus?
    
    var body: some View {
        HStack {
            Button {
                groceryVM.grocery.completed.toggle()
            } label: {
                Image(systemName: "\(groceryVM.grocery.completed ? "checkmark.circle.fill" : "checkmark.circle")")
            }
            .buttonStyle(.plain)
            .foregroundColor(groceryVM.grocery.completed ? .mint : .accentColor)
            .font(.system(.title2))
            
            ZStack(alignment: .leading) {
                TextField("...", text: $groceryVM.grocery.title) {
                    if groceryVM.grocery.title.isEmpty {
                        groceryVM.grocery.title = initialValue
                    }
                }
                .focused($focus, equals: .item)
                .scrollDismissesKeyboard(.immediately)
                
                Text(groceryVM.grocery.title)
                    .opacity(0.0)
                    .padding(.trailing, 10)
                    .overlay {
                        HStack {
                            Capsule()
                                .frame(maxWidth: groceryVM.grocery.completed ? .infinity : 0, maxHeight: 2, alignment: .leading)
                                .opacity(groceryVM.grocery.completed ? 1 : 0)
                            Spacer()
                        }
                    }
                    .animation(.easeOut(duration: 0.25), value: groceryVM.grocery.completed)
                
            }
            .allowsHitTesting(!groceryVM.grocery.completed)
            .foregroundColor(groceryVM.grocery.completed ? .secondary : .primary)
        }
        .font(.system(.body, design: .rounded, weight: .regular))
        .onChange(of: focus) { newValue in
            if newValue == .item {
                initialValue = groceryVM.grocery.title
            }
        }
        .task {
            initialValue = groceryVM.grocery.title
        }
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = examples[0]
        return GroceryView(groceryVM: GroceryViewModel(grocery: grocery))
    }
}
