//
//  ListItemRowView.swift
//  Tristy
//
//  Created by Frank Anderson on 5/16/22.
//

import SwiftUI

struct ListItemRowView: View {
    
    @Binding var item: TristyListItem
    @Binding var list: TristyList
    
    let addNewItem: () -> ()
    
    var body: some View {
        HStack {
            Button {
                item.isComplete.toggle()
            } label: {
                if (list.items.last?.title.count ?? 0) <= 0 && item.id == list.items.last?.id {
                    Label("",
                          systemImage: "checkmark.circle")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.clear)
                } else {
                    Label("\(item.isComplete ? "Unmark Item" : "Mark Item")",
                          systemImage: "\(item.isComplete ? "checkmark.circle.fill" : "checkmark.circle")")
                        .labelStyle(.iconOnly)
                }
            }
            
            TextField("New item ...", text: $item.title)
                .onChange(of: item.title) { newValue in
                    if (list.items.last?.title.count ?? 0) > 0 {
                        addNewItem()
                    }
                }
        }
    }
}

struct ListItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemRowView(item: .constant(TristyListItem.example), list: .constant(TristyList.example), addNewItem: {})
    }
}
