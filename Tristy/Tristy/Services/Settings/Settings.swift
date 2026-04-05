//
//  Settings.swift
//  Tristy
//
//  Created by Frank Anderson on 6/15/25.
//

import SwiftUI

struct Settings {
    
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
            case qty, uncertain, note, importance, pin, category, none, store
            
            var id: Self { self }
            
            #warning("Add fuller store controls like sorting")
            
            var name: String {
                switch self {
                case .store: "Store"
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
                case .store: Symbols.basket
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
                case .store:
                    Image(systemName: Symbols.basket)
                        .foregroundStyle(.green)
                }
            }
        }
        
        static let key = "icons"
        static let defaultValue: [Icon] = [.qty, .note, .uncertain, .importance, .pin, .category, .store]
        static let title = "Icons"
        static let caption = "Tap on the icons to change which ones are shown in the Shopping List."
    }
    
    struct Tabs {
        
        static let key = "tabs"
        static let defaultValue: Option = .archiveAsOwn
        static let title = "Tabs"
        static let caption = "How the lists and tabs should be organized."
        
        enum Option: String, CaseIterable, Codable, Identifiable {
            case singlePage = "singlePage"
            case eachAsOwn = "eachAsOwn"
            case archiveAsOwn = "archiveAsOwn"
            case activeAsOwn = "activeAsOwn"
            
            var id: String { self.rawValue }
            
            static let allCases: [Option] = [ .eachAsOwn, .singlePage, .activeAsOwn, .archiveAsOwn ]
            
            var title: String {
                switch self {
                case .singlePage:
                    return "Single page"
                case .eachAsOwn:
                    return "Tabbed"
                case .archiveAsOwn:
                    return "\(GroceryList.archive.name) tab"
                case .activeAsOwn:
                    return "\(GroceryList.active.name) tab"
                }
            }
            
            var description: String {
                switch self {
                case .singlePage:
                    return "All lists are on one page."
                case .eachAsOwn:
                    return "Each list is in its own tab."
                case .archiveAsOwn:
                    return "\(GroceryList.archive.name) has its own tab."
                case .activeAsOwn:
                    return "\(GroceryList.active.name) has its own tab."
                }
            }
            
            var symbolName: String {
                switch self {
                case .singlePage:
                    return "text.page"
                case .eachAsOwn:
                    return "rectangle.grid.3x1"
                case .archiveAsOwn:
                    return GroceryList.archive.symbolName
                case .activeAsOwn:
                    return GroceryList.active.symbolName
                }
            }
        }
        
        struct Menu: View {
            
            @AppStorage(Settings.Tabs.key) var tabChoice = Settings.Tabs.defaultValue
            
            var title: String { tabChoice.title }
            var symbol: String { tabChoice.symbolName }
            
            var picker: some View {
                Picker(title, selection: $tabChoice) {
                    ForEach(Settings.Tabs.Option.allCases) { tab in
                        Button {
                            tabChoice = tab
                        } label: {
                            Image(systemName: tab.symbolName)
                            Text(tab.title)
                            Text(tab.description)
                        }
                        .tag(tab)
                    }
                }
            }
            
            var body: some View {
                #if os(iOS)
                SwiftUI.Menu(title, systemImage: symbol) {
                    picker
                }
                #else
                picker
                    .labelsHidden()
                #endif
            }
        }
    }
    
    struct ListSort {
        static let key = "sort"
        static let defaultValue: [SortOption] = [.completed]
        static let title = "Sort"
        static let caption = "Which properties the list is sorted by."
        
        enum SortOption: String, Identifiable, Codable, CaseIterable {
            case store = "store"
            case category = "category"
            case completed = "completed"
            case pinned = "pinned"
            case uncertain = "uncertain"
            case importance = "importance"
            
            static let allCases: [Settings.ListSort.SortOption] = [
                .completed, .store, .category, .pinned, .importance, .uncertain
            ]
            
            var id: String { self.rawValue }
            
            var title: String {
                switch self {
                case .store: return "Store"
                case .category: return "Category"
                case .completed: return "Completed"
                case .pinned: return "Pinned"
                case .uncertain: return "Certainty"
                case .importance: return "Importance"
                }
            }
        }
    }
    
    /// ```swift
    /// // Usage ...
    /// @AppStorage(Settings.ShowPasteButton.key) var showPasteButton = Settings.ShowPasteButton.defaultValue
    /// ```
    struct ShowPasteButton {
        static let key = "showPasteButton"
        static let defaultValue = true
        static let title = "Show Paste Button"
        static let iconName = "document.on.clipboard"
        
        struct Toggle: View {
            
            @AppStorage(Settings.ShowPasteButton.key) var showPasteButton = Settings.ShowPasteButton.defaultValue
            
            var body: some View {
                
                SwiftUI.Toggle(Settings.ShowPasteButton.title, systemImage: Settings.ShowPasteButton.iconName, isOn: $showPasteButton)
            }
        }
    }
    
    struct MinimizeAddBar {
        
        static let key = "minimizeAddBar"
        static let defaultValue = true
        static let iconName = "text.magnifyingglass"
        static let title = "Minimize Add Bar"
        static let caption = "Minimize the search/add bar while scrolling."
        
        struct Toggle: View {
            
            @AppStorage(Settings.MinimizeAddBar.key) var minimizeAddBar = Settings.MinimizeAddBar.defaultValue
            var body: some View {
                SwiftUI.Toggle(isOn: $minimizeAddBar) {
                    Label(Settings.MinimizeAddBar.title, systemImage: Settings.MinimizeAddBar.iconName)
                }
                .help(Settings.MinimizeAddBar.caption)
            }
        }
        struct Button: View {
            
            @AppStorage(Settings.MinimizeAddBar.key) var minimizeAddBar = Settings.MinimizeAddBar.defaultValue
            var body: some View {
                SwiftUI.Button(action: { minimizeAddBar.toggle() }) {
                    Label(Settings.MinimizeAddBar.title, systemImage: Settings.MinimizeAddBar.iconName)
                }
                .help(Settings.MinimizeAddBar.caption)
            }
        }
    }
}
