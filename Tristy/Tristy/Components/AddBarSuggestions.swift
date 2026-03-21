//
//  AddBarSuggestions.swift
//  Tristy
//
//  Created by frank on 3/21/26.
//

import SwiftUI

struct AddBarSuggestions: View {
    
    var filteredItems: [Grocery]
    @Binding var query: String
    @Binding var isSearching: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(filteredItems) { grocery in
                    Button {
                        withAnimation {
                            query = ""
                            grocery.setList(.active)
                        }
                    } label: {
                        HStack {
                            Label(grocery.titleOrEmpty, systemImage: grocery.listEnum.symbolName)
                                .labelStyle(.tintedIcon(icon: grocery.listEnum.color))
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.top, grocery == filteredItems.first ? 15 : 0)
                        .padding(.bottom, grocery == filteredItems.last ? 15 : 0)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    
                    if grocery != filteredItems.last {
                        Divider()
                    }
                }
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: isSearching ? 240 : 0)
        .glassEffect(.regular, in: .containerRelative)
        .padding()
        
    }
}
