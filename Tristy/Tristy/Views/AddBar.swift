//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import SwiftUI

struct AddBar: View {
    
    @Environment(Store.self) var store
    @FocusState var addBarIsFocused: Bool
    
    let animationDuration: Double = 0.15
    @ScaledMetric var iconHeight: Double = 22
    
    var clipboardHasContents: Bool {
        !(UIPasteboard.general.string ?? "").isEmpty
    }
    
    var addBarQueryIsEmpty: Bool {
        store.addBarQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Shows either a "Paste" button or an "Add" button
    var leadingButton: some View {
        let decider = addBarQueryIsEmpty && clipboardHasContents
        
        return ZStack(alignment: .center) {
            if (decider) {
                TristyPasteButton { value in
                    store.appendToAddBarQuery(value)
                }
                .transition(.scale)
            } else {
                Button("Add", systemImage: "plus") {
                    store.addGroceries()
                }
                .transition(.scale)
            }
        }
        .labelStyle(.iconOnly)
        .foregroundStyle(addBarIsFocused ? .accent : .secondary)
        .animation(.easeInOut(duration: animationDuration), value: decider)
        .animation(.easeInOut(duration: animationDuration), value: addBarIsFocused)
        .frame(width: iconHeight, height: iconHeight)
    }
    
    /// Shows either a "Clear contents" button or a "Dismiss Keyboard" button
    var trailingButton: some View {
        ZStack(alignment: .center) {
            Group {
                if (addBarIsFocused) {
                    Button(
                        "Dismiss",
                        systemImage: Symbols.dismissKeyboard,
                        action: dismissKeyboard
                    )
                    .transition(.scale)
                }
                
                if (!addBarIsFocused && !addBarQueryIsEmpty) {
                    Button(
                        "Clear",
                        systemImage: Symbols.clearTextField,
                        action: store.clearAddBarQuery
                    )
                    .transition(.scale)
                }
            }
            .labelStyle(.iconOnly)
            .foregroundStyle(addBarIsFocused ? .accent : .secondary)
        }
        .animation(.easeInOut(duration: animationDuration), value: addBarIsFocused)
        .animation(.easeInOut(duration: animationDuration), value: !addBarIsFocused && !addBarQueryIsEmpty)
        .frame(width: iconHeight, height: iconHeight)
    }
    
    var body: some View {
        
        @Bindable var store = store
        
        HStack(alignment: .bottom) {
            leadingButton
            
            TextField(
                chooseRandomExampleGrocery(),
                text: store.addBarQueryBinding,
                axis: .vertical
            )
            .focused($addBarIsFocused)
            .onSubmit { store.addGroceries() }
            .submitLabel(.done)
            .readSize(onChange: { newSize in
                print(newSize.height)
            })
            .onChange(of: store.addBarQuery, handleChange)
            .onKeyPress(.escape) {
                addBarIsFocused = false
                return .handled
            }
            
            trailingButton
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 30.0))
    }
    
    
    
    /// If Return (\n) is pressed, decide to treat it as a submission or as inserting a new line based on if value is being removed (do not treat as submit; it's the user cleaning up a long pasting) or inserted (treat as a submission)
    /// - Parameters:
    ///   - oldValue: Previous value of the query
    ///   - newValue: New value of the query
    func handleChange(oldValue: String, newValue: String) {
        if (oldValue != "" && oldValue.count < newValue.count && oldValue.last != "\n" && newValue.last == "\n") {
            store.addGroceries()
        } else if (newValue == "\n") {
            addBarIsFocused = false
            store.clearAddBarQuery()
        }
    }
    
    /// Dismiss the keyboard by removing focus from addBar
    func dismissKeyboard() {
        addBarIsFocused = false
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
