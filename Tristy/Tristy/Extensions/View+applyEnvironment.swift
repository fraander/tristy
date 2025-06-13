//
//  View+ApplyEnvironment.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

/// Apply the whole collection of Services as a single modifier, instead of duplicating work in both @main and previews.
struct ApplyEnvironmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(Router())
            .environment(Store())
            .environment(Settings())
    }
}

extension View {
    func applyEnvironment() -> some View {
        self.modifier(ApplyEnvironmentModifier())
    }
}
