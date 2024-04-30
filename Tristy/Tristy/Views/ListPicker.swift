//
//  ListPicker.swift
//  Tristy
//
//  Created by Frank Anderson on 4/29/24.
//

import SwiftUI

struct ListPicker: View {
    @Binding var selectedList: GroceryList
    
    var body: some View {
        Picker(selection: $selectedList) {
            Group {
                ForEach(GroceryList.tabs, id: \.description) { tab in
                    Image(systemName: tab.symbol)
                        .tag(tab)
                }
            }
        } label: {
            Text("Tab")
        }
        .pickerStyle(.palette)
    }
}

#Preview {
    ListPicker(selectedList: .constant(.today))
}
