//
//  TristyPasteButton.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//


import SwiftUI

/// More customizable PasteButton than the built-in `PasteButton`. Drawback is that the user is requested for access to their clipboard when the view shows, not just when they try pasting (More frequently).
struct TristyPasteButton: View {
    
    /// Action to perform when the button is pressed. ie. What to do with the value from the clipboard.
    let onPaste: ((_ value: String) -> ())
    
    var pasteContent: String {
        #if os(iOS)
        UIPasteboard.general.string ?? ""
        #else
        NSPasteboard.general.string(forType: .string) ?? ""
        #endif
    }
    
    var body: some View {
        Button(
            "Paste",
            systemImage: Symbols.paste,
            action: {
                onPaste(pasteContent)
            }
        )
        .disabled(!clipboardHasValue)
    }
    
    /// True if the clipboard is not empty or unreadable
    var clipboardHasValue: Bool {
        !(pasteContent).isEmpty
    }
}
