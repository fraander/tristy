//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

/// Text field with ornaments to add values to the Grocery list. Broadcasts its query and focus value through an `AddBarStore` inserted in the environment.
struct AddBarTextField: View {
    
    @Environment(AddBarStore.self) var abStore
    @FocusState var focus: FocusOption?
    
    @ScaledMetric var iconHeight: Double = 22
    @State var prompt = ""
    
    var clipboardHasUsefulContents: Bool {
        let content = UIPasteboard.general.string ?? ""
        return !(content.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty
    }
    
    /// Shows either a "Paste" button or an "Add" button
    var leadingButton: some View {
        let decider = abStore.queryIsEmpty && clipboardHasUsefulContents
        
        return ZStack(alignment: .center) {
            if (decider) {
                TristyPasteButton { abStore.appendToQuery($0) }
                    .foregroundStyle(.accent)
                    .transition(.scale)
            } else {
                Button("Add", systemImage: "plus", action: abStore.addGroceries)
                    .foregroundStyle(abStore.isAddBarFocused ? .accent : .secondary)
                    .transition(.scale)
            }
        }
        .labelStyle(.iconOnly)
        .animation(.easeInOut(duration: Metrics.animationDuration), value: decider)
        .animation(.easeInOut(duration: Metrics.animationDuration), value: abStore.isAddBarFocused)
        .frame(width: iconHeight, height: iconHeight)
    }
    
    /// Shows either a "Clear contents" button or a "Dismiss Keyboard" button
    var trailingButton: some View {
        
        let showDismiss = abStore.focus != nil
        
        return ZStack(alignment: .center) {
            Group {
                if (!abStore.queryIsEmpty) {
                    Button(
                        "Clear",
                        systemImage: Symbols.clearTextField,
                        action: abStore.clearQuery
                    )
                    .transition(.scale)
                } else if (showDismiss) {
                    Button(
                        "Dismiss",
                        systemImage: Symbols.dismissKeyboard,
                        action: dismissKeyboard
                    )
                    .transition(.scale)
                }
            }
            .labelStyle(.iconOnly)
            .foregroundStyle(showDismiss ? .accent : .secondary)
        }
        .animation(.easeInOut(duration: Metrics.animationDuration), value: abStore.queryIsEmpty && showDismiss)
        .animation(.easeInOut(duration: Metrics.animationDuration), value: !abStore.queryIsEmpty)
        .frame(width: iconHeight, height: iconHeight)
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            leadingButton
            
            TextField(
                prompt,
                text: abStore.queryBinding,
                axis: .vertical
            )
            .focused($focus, equals: .addBar)
            .onChange(of: focus, { oldValue, newValue in
                abStore.setFocus(from: oldValue, to: newValue, for: .addBar)
            })
            .onChange(of: abStore.focus, { focus = $1 })
            .onSubmit { abStore.addGroceries() }
            .submitLabel(.done)
            .onChange(of: abStore.query, handleChange)
            .onKeyPress(.escape) {
                focus = nil
                return .handled
            }
            .task { prompt = chooseRandomExampleGrocery() }
            .task { focus = abStore.focus }
            
            trailingButton
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: Metrics.glassEffectRadius))
    }
    
    
    /// If Return (\n) is pressed, decide to treat it as a submission or as inserting a new line based on if value is being removed (do not treat as submit; it's the user cleaning up a long pasting) or inserted (treat as a submission)
    /// - Parameters:
    ///   - oldValue: Previous value of the query
    ///   - newValue: New value of the query
    func handleChange(oldValue: String, newValue: String) {
        if (oldValue != "" && oldValue.count < newValue.count && oldValue.last != "\n" && newValue.last == "\n") {
            abStore.addGroceries()
        } else if (newValue == "\n") {
            dismissKeyboard()
            abStore.clearQuery()
        }
    }
    
    /// Dismiss the keyboard by removing focus from addBar
    func dismissKeyboard() {
        abStore.removeFocus()
    }
    
    /// Choose a random grocery to use as an example
    /// - Returns: A random grocery from the list of 10
    func chooseRandomExampleGrocery() -> String {
        let groceries = ["Milk", "Bread", "Eggs", "Bananas", "Rice", "Onions", "Tomatoes", "Cheese", "Apples"]
        return groceries.randomElement() ?? "..."
    }
}

#Preview {
    ContentView()
        .applyEnvironment()
}
