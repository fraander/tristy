//
//  View+ApplyEnvironment.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

/// Apply the whole collection of Services as a single modifier, instead of duplicating work in both @main and previews.
struct ApplyEnvironmentModifier: ViewModifier {
    
    @State var router = Router()
    @State var abStore = AddBarStore()
    @State var settings = Settings()
    
    func body(content: Content) -> some View {
        content
            .environment(router)
            .environment(abStore)
            .environment(settings)
    }
}

extension View {
    /// Applies all necessary Environment services like `Router`, `AddBarStore`, `Settings`, and more!
    ///
    /// For use in **Previews**, override by applying the override before `.applyEnvironment` on the view.
    ///
    /// Example:
    /// ```swift
    /// #Preview {
    ///     // ✅ Correct: AddBar will have a query of "Eggs" and be focused (`isFocused = true`) in the preview. Even though the `.applyEnvironment()` default values are "" and unfocused (`isFocused = false`)
    ///     AddBar()
    ///         .environment(AddBarStore(query: "Eggs", isFocused: true) // Apply custom value *before* `.applyEnvironment()` to override
    ///         .applyEnvironment()
    ///
    ///     // ❌ Wrong: The custom values will not be used.
    ///     AddBar()
    ///         .applyEnvironment()
    ///         .environment(AddBarStore(query: "Eggs", isFocused: true) // Incorrect. The closed value to the view in the tree is used.
    /// }
    /// ```
    func applyEnvironment() -> some View {
        self.modifier(ApplyEnvironmentModifier())
    }
}
