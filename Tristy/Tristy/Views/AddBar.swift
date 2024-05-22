//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 4/28/24.
//

import SwiftUI
import SwiftData

struct AddBar: View {
    
    let abpTip = AddBarPasteTip()
    
    var list: GroceryList
    @State var text = ""
    @Environment(\.modelContext) var modelContext
    @FocusState var focusState: FocusOption?
    @Query var groceries: [Grocery]
    
    var body: some View {
        VStack {
            Spacer()
            
            AddBarQuery(text: $text, list: list, focusState: $focusState)
            
            HStack {
                    Button(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Paste" : "Add",
                       systemImage: text == "" ? "doc.on.clipboard" : "plus",
                       action: {
                    if (text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                        #if os(iOS)
                        text = UIPasteboard.general.string ?? ""
                        #else
                        text = NSPasteboard.general.string(forType: .string) ?? ""
                        #endif
                        focusState = .addBar
                        abpTip.invalidate(reason: .actionPerformed)
                    } else {
                        addGrocery(title: text)
                    }
                })
#if os(macOS)
                .buttonStyle(.plain)
#endif
                .labelStyle(.iconOnly)
                .tint(focusState == .addBar ? Color.accentColor : Color.secondary)
                .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                .animation(.easeInOut(duration: 0.15), value: text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .contentTransition(.symbolEffect(.replace))
                #if os(iOS)
                .popoverTip(abpTip, arrowEdge: .bottom)
                #endif
                
                TextField("Add item...", text: $text, axis: .vertical)
#if os(macOS)
                    .textFieldStyle(.plain)
#endif
                    .focused($focusState, equals: .addBar)
                    .onSubmit {
                        addGrocery(title: text)
                    }
                    .onChange(of: text) { oldValue, newValue in
                        if (oldValue != "" && oldValue.count < newValue.count && oldValue.last != "\n" && newValue.last == "\n") {
                            addGrocery(title: oldValue)
                        } else if (newValue == "\n") {
                            focusState = nil
                            text = ""
                        }
                    }
                    .submitLabel(.done)
                    .font(.system(.body, design: .rounded))
                    .onKeyPress(.escape) {
                        focusState = nil
                        return .handled
                    }
                
                Button(focusState == .addBar ? "Hide" : "Clear", systemImage: focusState == .addBar ? "keyboard.chevron.compact.down" : "delete.backward", action: {
                    if (focusState != .addBar) {
                        text = ""
                    }
                    focusState = focusState == .addBar ? nil : .addBar
                })
                .labelStyle(.iconOnly)
                #if os(macOS)
                .buttonStyle(.plain)
#endif
                .foregroundStyle(focusState == .addBar ? Color.accentColor : Color.secondary)
                .opacity( focusState == .addBar || !text.isEmpty ? 0.5 : 0)
                .animation(.easeInOut(duration: 0.15), value: focusState == .addBar && !text.isEmpty)
                .contentTransition(.symbolEffect(.replace))
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10.0)
#if os(iOS)
                    .strokeBorder(Color.secondary, lineWidth: 1)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.background)
                    }
#else
                    .fill(Material.regular)
#endif
#if os(iOS)
                    .shadow(
                        color: focusState == .addBar ? Color.accentColor : Color.clear,
                        radius: focusState == .addBar ? 3 : 0
                    )
                    .animation(Animation.easeInOut(duration: 0.25), value: focusState == .addBar)
#endif
            }
        }
        .padding()
    }
    
    private func addGrocery(title: String) {
        
        if (!text.isEmpty) {
            let parts = title.components(separatedBy: .newlines)
            for part in parts {
                
                let trimmed = part.trimmingCharacters(in: .whitespaces)
                if let found = groceries.first(where: { g in
                    g.title.lowercased() == trimmed.lowercased()
                }) {
                    found.when = list.description
                    found.completed = false
                } else {
                    let grocery = Grocery(title: trimmed, when: list)
                    modelContext.insert(grocery)
                }
                
            }
            text = ""
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Grocery.self, configurations: config)
    
    container.mainContext.insert(Grocery(title: "Testing"))
    container.mainContext.insert(Grocery(title: "Testing3"))
    
    return AddBar(list: .today)
        .modelContainer(container)
}
