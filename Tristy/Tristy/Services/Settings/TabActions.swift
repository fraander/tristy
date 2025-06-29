//
//  TabActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/29/25.
//

import SwiftUI

struct TabActions: View {
    
    @AppStorage(Settings.Tabs.key) var tabs = Settings.Tabs.defaultValue
    
    var body: some View {
        
        LabeledContent {
            Settings.Tabs.Menu()
                .frame(height: 28)
        } label: {
            Label("Tabs", systemImage: tabs.symbolName)
                .labelStyle(.tintedIcon(icon: .accent))
                .symbolVariant(.fill)
                .contentTransition(.symbolEffect)
        }
        
//        CaptionedListRow(caption: Settings.Tabs.caption) {
//            LabeledContent {
//                Settings.Tabs.Menu()
//                    .frame(height: 28)
//            } label: {
//                Label("Tabs", systemImage: tabs.symbolName)
//                    .labelStyle(.tintedIcon(icon: .accent))
//                    .symbolVariant(.fill)
//                    .contentTransition(.symbolEffect)
//            }
//        }
    }
}

#Preview {
    List {
        TabActions()
    }
}
