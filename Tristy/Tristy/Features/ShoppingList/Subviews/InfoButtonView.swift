//  InfoButtonView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI

struct InfoButtonView: View {
    @Binding var showInfo: Bool
    let grocery: Grocery
    var namespace: Namespace.ID
    
    var body: some View {
        Button {
            showInfo = true
        } label: {
            Label("Info", systemImage: Symbols.info)
        }
        .matchedTransitionSource(id: "info_\(grocery.persistentModelID)", in: namespace)
        .tint(.gray)
    }
}
