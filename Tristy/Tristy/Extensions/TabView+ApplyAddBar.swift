//
//  ApplyAddBarToTabViewModifier.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI


/// Adds an AddBar to the bottom of the TabView, aligned to the first item in the tabs list to pop in and out correctly positioned.
struct ApplyAddBarModifier: ViewModifier {
    
    @Environment(Router.self) var router
    @Environment(AddBarStore.self) var abStore
    
    let hasSearch: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if router.tab == .shoppingList {
                    AddBar()
                        .padding(.horizontal)
                        .padding(.bottom, abStore.isFocused ? 10 : 60)
                        .transition(
                            .opacity.combined(with:
                                    .scale(0.0, anchor: anchor))
                        )
                }
            }
            .animation(.bouncy, value: router.tab == .shoppingList)
    }
    
    var anchor: UnitPoint {
        if hasSearch {
            return .init(x: 0.12, y: 1)
        } else {
            return  .init(x: 0.44, y: 1)
        }
    }
}

extension TabView {
    /// Adds an AddBar to the bottom of the TabView, aligned to the first item in the tabs list to pop in and out correctly positioned.
    /// - Parameter hasSearch: if a tab with .search is in the TabView, mark as true to correct the positioning
    func applyAddBar(hasSearch: Bool) -> some View {
        self.modifier(ApplyAddBarModifier(hasSearch: hasSearch))
    }
}
