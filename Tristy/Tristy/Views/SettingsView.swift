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
            
            Section("Lists") {
                TabActions()
                SortActions()
                
                CaptionedListRow(caption: Settings.HideCompleted.caption) {
                    Settings.HideCompleted.Toggle()
                }
                
                CaptionedListRow(caption: Settings.CollapsibleSections.caption) {
                    Settings.CollapsibleSections.Toggle()
                }
            }
            
            Section("Preferences") {
                Settings.AddBarSuggestions.Toggle()

                Settings.ShowPasteButton.Toggle()
                
                
//                Settings.CompletedToBottom.Toggle()
//                Settings.SortByCategory.Toggle()
            }
            
            IconActions()
            
            Section("Stores") { StoreActions() }
            
            Section("iCloud") { SyncStatusView() }
            
            Section("Data Actions") { DataActions() }
        }
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            content
            .tint(.accent)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: Symbols.dismissSheet) {
                        dismiss()
                    }
                    .tint(.accent)
                }
            }
        }
        #else
        NavigationStack {
            content
        }
        #endif
    }
}

#Preview("In SettingsView context") {
    SettingsView()
        .applyEnvironment()
}
