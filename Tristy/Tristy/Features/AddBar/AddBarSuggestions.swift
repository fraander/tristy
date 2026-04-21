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
                        #if os(iOS)
                        .padding(.top, grocery == addBarService.filteredItems.first ? 15 : 0)
                        #else
                        .padding(.top, grocery == addBarService.filteredItems.first ? 10 : 0)
                        .padding(.bottom, grocery == addBarService.filteredItems.last ? 10 : 0)
                        #endif
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
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
            #if os(iOS)
            .padding(10)
            #endif
        }
        .frame(maxWidth: 360, maxHeight: addBarService.isSearching ? 180 : 0)
        .clipShape(.containerRelative)
        .glassEffect(.regular, in: .rect(
                               corners: .concentric(minimum: .fixed(16)), // Fixed minimum fallback
                               isUniform: true
                           ))
        #if os(iOS)
        .padding()
        #else
        .padding(.trailing, 5)
        #endif
        
    }
}
