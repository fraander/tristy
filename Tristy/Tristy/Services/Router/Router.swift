//
//  Router.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Observation
import SwiftUI

@Observable
class Router {
    init(
        tab: TristyTab = .today,
        sheet: TristySheet? = nil,
        focus: FocusOption? = nil
    ) {
        self.tab = tab
        self.sheet = sheet
        self.focus = focus
    }
    
    // MARK: FOCUS -
    /// To sync `focus` with `@FocusState` values inside views use this `onChange(old,new,action)` approach:
    /// ```swift
    /// @Environment(AddBarStore.self) var abStore
    /// @FocusState var focus: FocusOption?
    /// let focusOptionForField = /* ... */
    ///
    /// var body: some View {
    ///     // ... body contents ...
    ///         .focused($focus, equals: focusOptionForField) // marks for what value of `focus` the field should capture focus
    ///         .onChange(of: focus, { oldValue, newValue in
    ///              abStore.updateFocus(from: oldValue, to: newValue, for: focusOptionForField)
    ///         }) // updates `router.focus` as the `@FocusState` value changes
    ///         .onChange(of: router.focus, { focus = $1 }) // updates the `@FocusState` value as `router.focus` changes
    /// }
    /// ```
    private(set) var focus: FocusOption?
    
    /// Accept change in focus if to == for. Use in `onChange` to update AddBarStore to match @FocusState inside a view.
    /// - Parameters:
    ///   - prevOption: What the focus value used to be at the call site
    ///   - newOption: What the new focus value should be at the call site
    ///   - source: Which caller is setting focus
    func updateFocus(from prevOption: FocusOption? , to newOption: FocusOption?, for source: FocusOption) {
        if newOption == source {
            self.focus = newOption
        }
    }
    
    /// Ignore from-to-for notation and override the focus. Good for setting focus manually with a button. **DO NOT use to sync `AddBarStore.focus` to `@FocusState`.** Use `updateFocus(from:,to:,for:)` instead for that purpose.
    /// - Parameter option: Where to direct focus in the application.
    func setFocus(to option: FocusOption) {
        self.focus = option
    }
    
    /// Set focus to nil - explicit call required
    func removeFocus() { self.focus = nil }
    
    /// Does `router.focus == .addBar`?
    var isAddBarFocused: Bool { focus == .addBar }
    
    // MARK: TAB -
    private(set) var tab: TristyTab = .today
    var tabBinding: Binding<TristyTab> {
        .init(
            get: { self.tab },
            set: { self.tab = $0 }
        )
    }
    
    func setTab(to tab: TristyTab) {
        self.tab = tab
    }
    
    // MARK: SHEET -
    private(set) var sheet: TristySheet? = nil
    var sheetBinding: Binding<Bool> {
        .init(
            get: { self.sheet != nil },
            set: { newValue in
                if !newValue {
                    self.sheet = nil
                }
            }
        )
    }
    
    func presentSheet(_ sheet: TristySheet) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
}
