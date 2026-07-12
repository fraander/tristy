//  GrocerySectionView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI
import SwiftData

struct GrocerySectionView: View {
    @Binding var groceries: [GroceryDraft]
    let isBulkMode: Bool
    let consensusCategory: GroceryCategory?
    let hasConsensusStore: Bool
    let consensusList: GroceryList?
    let stores: [GroceryStore]
    let animationAngle: CGFloat
    let categoryBinding: Binding<GroceryCategory?>
    let listBinding: Binding<GroceryList?>
    let nilStore: GroceryStore
    let storeBinding: Binding<GroceryStore?>
    
    var body: some View {
        Group {
            let titleBinding = Binding<String> {
                groceries.first?.workingTitle ?? ""
            } set: { newValue in
                groceries.enumerated().forEach { index, _ in
                    groceries[index].workingTitle = newValue
                    groceries[index].hasChangedWorkingTitle = true
                }
            }
            if !isBulkMode {
                TextField("Title", text: titleBinding)
            }
            // ...
            // The rest of the original grocerySection content goes here using the above bindings and inputs.
        }
    }
}
