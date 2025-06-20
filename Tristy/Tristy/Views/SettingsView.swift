//
//  SettingsView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(Router.self) var router
    
    @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
    
    var content: some View {
        List {
            Section("Share") { ShareActions() }
            
            Section("Preferences") {
                Settings.AddBarSuggestions.Toggle()

                CaptionedListRow(caption: Settings.HideCompleted.caption) {
                    Settings.HideCompleted.Toggle()
                }
                
                CaptionedListRow(caption: Settings.CollapsibleSections.caption) {
                    Settings.CollapsibleSections.Toggle()
                }
                
                Settings.CompletedToBottom.Toggle()
                
                Settings.SortByCategory.Toggle()
            }
            
            IconActions()
            
            Section("iCloud") { SyncStatusView() }
            
            Section("Data Actions") { DataActions() }
        }
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            content
            .tint(.accent)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: Symbols.dismissSheet) {
                        router.dismissSheet()
                    }
                    .tint(.accent)
                }
            }
        }
        #else
        NavigationStack {
            content
        }
        .frame(maxWidth: 360)
        #endif
    }
}

#Preview("In SettingsView context") {
    SettingsView()
        .applyEnvironment()
}
