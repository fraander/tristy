//
//  SheetSwitchView.swift
//  Tristy
//
//  Created by frank on 7/12/26.
//

import SwiftUI

struct SheetSwitchView: View {
    
    @Environment(Router.self) var router: Router
    let namespace: Namespace.ID
    
    var body: some View {
        Group {
            if let sheet = router.sheet {
                switch sheet {
                    case .settings: SettingsView()
#if os(iOS)
                            .navigationTransition(.zoom(sourceID: "settings", in: namespace))
#endif
                    case .grocery(let type): GroceryDetailView(type: type)
                }
            }
        }
    }
}

