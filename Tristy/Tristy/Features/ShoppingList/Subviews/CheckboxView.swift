//  CheckboxView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI

struct CheckboxView: View {
    @Bindable var grocery: Grocery
    
    var body: some View {
        Button("Complete grocery", systemImage: Symbols.complete) {
            grocery.toggleCompleted()
        }
        .symbolToggleEffect(grocery.isCompleted, activeVariant: .circle.fill, inactiveVariant: .circle)
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .foregroundColor(grocery.isCompleted ? .mint : .accentColor)
        .animation(.easeOut(duration: 0.25), value: grocery.isCompleted)
        .font(.system(.title2))
    }
}
