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
    var text: String
    
    init(text: String, list: GroceryList) {
        self.text = text
        self.list = list
        _groceries = Query(filter: #Predicate<Grocery> {
            return ($0.when ?? "") != list.description && (text.isEmpty || $0.title.localizedStandardContains(text))
        }, sort: \Grocery.title, order: .reverse, animation: .default)
    }
    
    var body: some View {
        List(groceries) { grocery in
            Button {
                grocery.when = list.description
                grocery.completed = false
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
        .frame(minHeight: 0, idealHeight: 0, maxHeight: min(60 * CGFloat(groceries.count), 240), alignment: .bottom)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .padding(2)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .opacity(groceries.count > 0 ? 1 : 0)
        .animation(.easeInOut, value: groceries.count)
    }
}
