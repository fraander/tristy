//
//  TabView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(Router.self) var router
    @Environment(Store.self) var store
    
    var isTabOnShoppingList: Bool {
        router.tab == .shoppingList
    }
    
    var body: some View {
        
        @Bindable var store = store
        
        
        // VIEW CONTENTS -
        
        TabView(selection: router.tabBinding) {
            ForEach(TristyTab.allCases) { tab in
                Tab(
                    tab.rawValue,
                    systemImage: tab.symbolName,
                    value: tab,
                    role: tab.role,
                    content: {
                        tab.correspondingView
                    }
                )
            }
        }
        .applyAddBarToTabView()
        .animation(.bouncy, value: router.tab == .shoppingList)
    }
    
    
}

struct ApplyAddBarToTabViewModifier: ViewModifier {
    
    @Environment(Router.self) var router
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if router.tab == .shoppingList {
                    AddBar()
                        .padding(.horizontal)
                        .padding(.bottom, 60)
                        .transition(
                            .opacity.combined(with:
                                    .scale(0.0, anchor: .init(x: 0.12, y: 1))
                            )
                        )
                }
            }
    }
}

extension View {
    func applyAddBarToTabView() -> some View {
        self.modifier(ApplyAddBarToTabViewModifier())
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
