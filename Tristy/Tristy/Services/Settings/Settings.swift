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
                    .symbolToggleEffect(showAddBarSuggestions)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.AddBarSuggestions.key) var showAddBarSuggestions = Settings.AddBarSuggestions.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.AddBarSuggestions.title, systemImage: Settings.AddBarSuggestions.iconName) {
                    showAddBarSuggestions.toggle()
                }
                .symbolToggleEffect(showAddBarSuggestions)
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
                    .symbolToggleEffect(hideCompleted, activeVariant: .circle)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.HideCompleted.key) var hideCompleted = Settings.HideCompleted.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.HideCompleted.title, systemImage: Settings.HideCompleted.iconName) {
                    hideCompleted.toggle()
                }
                .symbolToggleEffect(hideCompleted, activeVariant: .circle)
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
                    .symbolToggleEffect(collapsibleSections)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.CollapsibleSections.key) var collapsibleSections = Settings.CollapsibleSections.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.CollapsibleSections.title, systemImage: Settings.CollapsibleSections.iconName) {
                    collapsibleSections.toggle()
                }
                .symbolToggleEffect(collapsibleSections)
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
                    .symbolToggleEffect(completedToBottom)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(Settings.CompletedToBottom.key) var completedToBottom = Settings.CompletedToBottom.defaultValue
            
            var body: some View {
                SwiftUI.Button(Settings.CompletedToBottom.title, systemImage: Settings.CompletedToBottom.iconName(isActive: completedToBottom)) {
                    completedToBottom.toggle()
                }
                .symbolToggleEffect(completedToBottom)
            }
        }
    }
    
    /// Should the `ShoppingList` sort by GroceryCategory.sortOrder?
    ///
    /// # Usage
    /// ```swift
    /// @AppStorage(Settings.SortByCategory.key) var sortByCategory = Settings.sortByCategory.defaultValue
    /// ```
    struct SortByCategory {
        static let key = "sortByCategory"
        static let defaultValue = true
        static let iconName = Symbols.category
        static let title = "Sort by Category"
        static let caption = "Choose if the Shopping List should sort by Category in the list."
        
        /// SwiftUI-style Toggle to control the property
        struct Toggle: View {
            @AppStorage(SortByCategory.key) var sortByCategory = SortByCategory.defaultValue
            
            var body: some View {
                SwiftUI.Toggle(SortByCategory.title, systemImage: SortByCategory.iconName, isOn: $sortByCategory)
                    .symbolToggleEffect(sortByCategory)
            }
        }
        
        /// SwiftUI-style Button to control the property
        struct Button: View {
            
            @AppStorage(SortByCategory.key) var sortByCategory = SortByCategory.defaultValue
            
            var body: some View {
                SwiftUI.Button(SortByCategory.title, systemImage: SortByCategory.iconName) {
                    sortByCategory.toggle()
                }
                .symbolToggleEffect(sortByCategory)
            }
        }
    }
    
    /// What icons and in what order should they be shown on the `GroceryListRow` and in `GroceryListRowIcons`
    ///
    /// # Usage
    /// ```swift
    /// @AppStorage(Settings.Icons.key) var icons = Settings.Icons.defaultValue
    /// ```
    struct Icons {
        
        enum Icon: Identifiable, CaseIterable, Codable {
            case qty, uncertain, note, importance, pin, category, none
            
            var id: Self { self }
            
            var name: String {
                switch self {
                case .qty: "Quantity"
                case .uncertain: "Certainty"
                case .note: "Note"
                case .importance: "Importance"
                case .pin: "Pinned"
                case .category: "Category"
                case .none: "None"
                }
            }
            
            var symbolName: String {
                switch self {
                case .qty: Symbols.quantity
                case .uncertain: Symbols.uncertain
                case .note: Symbols.notes
                case .importance: GroceryImportance.somewhat.symbolName
                case .pin: Symbols.pinned
                case .category: Symbols.category
                case .none: Symbols.none
                }
            }
            
            @ViewBuilder
            func correspondingPreviewView() -> some View {
                switch self {
                case .qty:
                    Text("1 cup")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle( Color.primary.mix(with: .secondary, by: 0.75))
                case .uncertain:
                    Image(systemName: Symbols.uncertain)
                        .foregroundStyle(.indigo)
                        .symbolVariant(.fill)
                case .note:
                    Image(systemName: Symbols.notes)
                        .foregroundStyle(.yellow)
                case .importance:
                    Image(systemName: GroceryImportance.somewhat.symbolName)
                        .foregroundStyle(GroceryImportance.somewhat.color)
                case .pin:
                    Image(systemName: Symbols.pinned)
                        .foregroundStyle(.orange)
                        .symbolVariant(.fill)
                case .category:
                    Image(systemName: Symbols.category)
                        .foregroundStyle(.green)
                        .symbolVariant(.fill)
                case .none:
                    Image(systemName: Symbols.none)
                        .foregroundStyle(.secondary.opacity(0.7))
                }
            }
        }
        
        static let key = "completedToBottom"
        static let defaultValue: [Icon] = [.qty, .uncertain, .note, .importance, .pin, .category]
        static let title = "Icons"
        static let caption = "Tap on the icons to change which ones are shown in the Shopping List."
    }
}
