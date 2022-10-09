//
//  SwiftUIView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI

struct GroceryView: View {
    var groceryVM: GroceryViewModel
    
    var body: some View {
        Text(groceryVM.grocery.title)
    }
    
    func update(grocery: Grocery) {
        groceryVM.update(grocery: grocery)
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = testData[0]
        return GroceryView(groceryVM: GroceryViewModel(grocery: grocery))
    }
}
