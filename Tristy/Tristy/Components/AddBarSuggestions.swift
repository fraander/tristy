//
//  AddBarSuggestions.swift
//  Tristy
//
//  Created by frank on 3/21/26.
//

import SwiftUI

struct AddBarSuggestions: View {
    
    @Bindable var addBarService: AddBarService
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(addBarService.filteredItems) { grocery in
                    Button {
                        withAnimation {
                            addBarService.moveGroceryToActive(grocery: grocery)
                            addBarService.query.removeAll()
                        }
                    } label: {
                        HStack {
                            Label(grocery.titleOrEmpty, systemImage: grocery.listEnum.symbolName)
                                .labelStyle(.tintedIcon(icon: grocery.listEnum.color))
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.top, grocery == addBarService.filteredItems.first ? 15 : 0)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    
                    if grocery != addBarService.filteredItems.last || addBarService.showPlusButton {
                        Divider()
                    }
                }
                
                if addBarService.showPlusButton {
                    Button {
                        withAnimation {
                            addBarService.createGroceryFromQuery()
                        }
                    } label: {
                        HStack {
                            Label(addBarService.trimmedQuery, systemImage: "plus")
                                .labelStyle(.tintedIcon(icon: .accentColor))
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                }
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: addBarService.isSearching ? 180 : 0)
        .clipShape(.containerRelative)
        .glassEffect(.regular, in: .containerRelative)
        .padding()
        
    }
}
