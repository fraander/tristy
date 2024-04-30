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
    var text: String
    
    init(text: String) {
        self.text = text
        _groceries = Query(filter: #Predicate<Grocery> {
            if text.isEmpty {
                return true
            } else {
                return $0.title.localizedStandardContains(text)
            }
        }, sort: \Grocery.title, order: .reverse, animation: .default)
    }
    
    var body: some View {
    
        ScrollView {
            VStack {
                ForEach(groceries) { grocery in
                    Text(grocery.title)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
