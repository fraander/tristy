//
//  Settings.swift
//  Tristy
//
//  Created by Frank Anderson on 6/15/25.
//

import SwiftUI

struct Settings {
    /// Should the `AddBar` show the suggestions pane above the bar?
    ///
    /// # Usage
    /// ```swift
    /// @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
    /// ```
    struct AddBarSuggestions {
        static let key = "showAddBarSuggestions"
        static let defaultValue = true
        static let iconName = Symbols.addBarSuggestions
        static let title = "Add Bar suggestions"
        
        /// SwiftUI-style Toggle to control the property
        struct Toggle: View {
            @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
            
            var body: some View {
                SwiftUI.Toggle(Settings.AddBarSuggestions.title, systemImage: Settings.AddBarSuggestions.iconName, isOn: $showAddBarSuggestions)
                    .symbolToggleEffectViewModifier(showAddBarSuggestions)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.AddBarSuggestions.title, systemImage: Settings.AddBarSuggestions.iconName) {
                    showAddBarSuggestions.toggle()
                }
                .symbolToggleEffectViewModifier(showAddBarSuggestions)
            }
        }
    }
    
    /// Should the `ShoppingList` show completed tasks in the expanded way?
    ///
    /// # Usage
    /// ```swift
    /// @AppStorage(Settings.HideCompleted.key) var hideCompleted = Settings.HideCompleted.defaultValue
    /// ```
    struct HideCompleted {
        static let key = "hideCompleted"
        static let defaultValue = true
        static let iconName = Symbols.filter
        static let title = "Hide completed groceries"
        static let caption = "Choose if the Shopping List should show completed groceries."
        
        /// SwiftUI-style Toggle to control the property
        struct Toggle: View {
            @AppStorage(Settings.HideCompleted.key) var hideCompleted = Settings.HideCompleted.defaultValue
            
            var body: some View {
                SwiftUI.Toggle(Settings.HideCompleted.title, systemImage: Settings.HideCompleted.iconName, isOn: $hideCompleted)
                    .symbolToggleEffectViewModifier(hideCompleted, activeVariant: .circle)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.HideCompleted.key) var hideCompleted = Settings.HideCompleted.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.HideCompleted.title, systemImage: Settings.HideCompleted.iconName) {
                    hideCompleted.toggle()
                }
                .symbolToggleEffectViewModifier(hideCompleted, activeVariant: .circle)
            }
        }
    }
    
    /// Allow the Today and Next Time lists to be collapsed.
    ///
    /// # Usage
    /// ```swift
    /// @AppStorage(Settings.CollapsibleSections.key) var collapsibleSections = Settings.collapsibleSections.defaultValue
    /// ```
    struct CollapsibleSections {
        static let key = "collapsibleSections"
        static let defaultValue = true
        static let iconName = Symbols.collapsibleSections
        static let title = "Collapsible Sections"
        static let caption = "Allow the Today and Next Time lists to be collapsed."
        
        /// SwiftUI-style Toggle to control the property
        struct Toggle: View {
            @AppStorage(Settings.CollapsibleSections.key) var collapsibleSections = Settings.CollapsibleSections.defaultValue
            
            var body: some View {
                SwiftUI.Toggle(Settings.CollapsibleSections.title, systemImage: Settings.CollapsibleSections.iconName, isOn: $collapsibleSections)
                    .symbolToggleEffectViewModifier(collapsibleSections)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.CollapsibleSections.key) var collapsibleSections = Settings.CollapsibleSections.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.CollapsibleSections.title, systemImage: Settings.CollapsibleSections.iconName) {
                    collapsibleSections.toggle()
                }
                .symbolToggleEffectViewModifier(collapsibleSections)
            }
        }
    }
    
    /// Should the `ShoppingList` show completed tasks in the expanded way?
    ///
    /// # Usage
    /// ```swift
    /// @AppStorage(Settings.CompletedToBottom.key) var completedToBottom = Settings.CompletedToBottom.defaultValue
    /// ```
    struct CompletedToBottom {
        static let key = "completedToBottom"
        static let defaultValue = true
        static let activeIconName = Symbols.completedToBottom
        static let inactiveIconName = Symbols.completedToBottomInactive
        static let title = "Completed to bottom"
        static let caption = "Choose if the Shopping List should show completed groceries in the list."
        
        static func iconName(isActive: Bool) -> String {
            return isActive ? activeIconName : inactiveIconName
        }
        
        /// SwiftUI-style Toggle to control the property
        struct Toggle: View {
            @AppStorage(Settings.CompletedToBottom.key) var completedToBottom = Settings.CompletedToBottom.defaultValue
            
            var body: some View {
                SwiftUI.Toggle(Settings.CompletedToBottom.title, systemImage: Settings.CompletedToBottom.iconName(isActive: completedToBottom), isOn: $completedToBottom)
                    .symbolToggleEffectViewModifier(completedToBottom)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.CompletedToBottom.key) var completedToBottom = Settings.CompletedToBottom.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.CompletedToBottom.title, systemImage: Settings.CompletedToBottom.iconName(isActive: completedToBottom)) {
                    completedToBottom.toggle()
                }
                .symbolToggleEffectViewModifier(completedToBottom)
            }
        }
    }
}
