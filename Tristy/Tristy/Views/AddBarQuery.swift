//
//  AddBarQuery.swift
//  Tristy
//
//  Created by Frank Anderson on 4/29/24.
//

import SwiftUI
import SwiftData
import NaturalLanguage

struct AddBarQuery: View {
    @Query var groceries: [Grocery]
    var list: GroceryList
    @Binding var text: String
    var focusState: FocusState<FocusOption?>.Binding
    
    init(text: Binding<String>, list: GroceryList, focusState: FocusState<FocusOption?>.Binding) {
        _text = text
        self.list = list
        self.focusState = focusState
        
        let textValue = text.wrappedValue
        _groceries = Query(filter: #Predicate<Grocery> {
            return ($0.when ?? "") != list.description && (textValue.isEmpty || $0.title.localizedStandardContains(textValue))
        }, sort: \Grocery.title, order: .reverse, animation: .default)
    }
    
    var body: some View {
        List(groceries) { grocery in
            Button {
                grocery.when = list.description
                grocery.completed = false
                text = ""
            } label: {
                HStack {
                    Text(grocery.title)
                        .foregroundStyle(.primary)
                    Spacer()
                    
                    if let groceryEnum = GroceryList.toEnum(grocery.when ?? "") {
                        Image(systemName: groceryEnum.symbol)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .frame(minHeight: 0, idealHeight: 0, maxHeight: min(60 * CGFloat(groceries.count), 130), alignment: .bottom)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .padding(2)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .opacity(groceries.count > 0 ? 1 : 0)
        .animation(.easeInOut, value: groceries.count)
        // from outer view
        .background {
            RoundedRectangle(cornerRadius: 10.0)
                .strokeBorder(Color.secondary, lineWidth: 1)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                    #if os(iOS)
                        .fill(Color(uiColor: .systemBackground))
                    #else
                        .fill(Color(nsColor: .windowBackgroundColor))
                    #endif
                }
        }
        .opacity( focusState.wrappedValue == .addBar && groceries.count > 0 ? 1 : 0)
        .animation(.easeInOut(duration: 0.15), value: focusState.wrappedValue == .addBar && groceries.count > 0)
    }
}
