//
//  SettingsView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct Settings {
    /// @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
    struct AddBarSuggestions {
        
        @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
        
        static let key = "showAddBarSuggestions"
        static let defaultValue = true
        static let iconName = Symbols.addBarSuggestions
        static let title = "Add Bar suggestions"
        
        var control: some View {
            Toggle(Settings.AddBarSuggestions.title, systemImage: Settings.AddBarSuggestions.iconName, isOn: $showAddBarSuggestions)
        }
    }
}

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
                    Settings.AddBarSuggestions().control
                        .tint(.accent)
                }
                
                Section("Data Actions") {
                    DataActions()
                }
            }
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

#Preview {
    SettingsView()
        .applyEnvironment()
}
