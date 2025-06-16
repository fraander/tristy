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
    
    var body: some View {
        NavigationView {
            List {
                Section("iCloud") {
                    SyncStatusView()
                }
                
                Section("Preferences") {
                    Settings.AddBarSuggestions.Toggle()

                    CaptionedListRow(caption: Settings.HideCompleted.caption) {
                        Settings.HideCompleted.Toggle()
                    }
                    
                    CaptionedListRow(caption: Settings.CollapsibleSections.caption) {
                        Settings.CollapsibleSections.Toggle()
                    }
                    
                    Settings.CompletedToBottom.Toggle()

                    
                    
                }
                
                Section("Data Actions") {
                    DataActions()
                }
            }
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
    }
}

#Preview("In SettingsView context") {
    SettingsView()
        .applyEnvironment()
}
