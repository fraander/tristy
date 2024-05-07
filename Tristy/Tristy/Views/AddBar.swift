//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 4/28/24.
//

import SwiftUI
import SwiftData

struct AddBar: View {
    
    var list: GroceryList
    @State var text = ""
    @Environment(\.modelContext) var modelContext
    @FocusState var focusState: Bool
    @Query var groceries: [Grocery]
    
    var body: some View {
        VStack {
            Spacer()
            
            AddBarQuery(text: text, list: list)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(Color.secondary, lineWidth: 1)
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemBackground))
                        }
                }
                .opacity( focusState ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: focusState)
            
            HStack {
                Button("Add",
                       systemImage: "plus",
                       action: { addGrocery(title: text) })
                .labelStyle(.iconOnly)
                .tint(focusState ? Color.accentColor : Color.secondary)
                
                TextField("Add item...", text: $text, axis: .vertical)
                    .focused($focusState)
                    .onSubmit {
                        addGrocery(title: text)
                    }
                    .submitLabel(.done)
                
                Button(focusState ? "Hide" : "Clear", systemImage: focusState ? "keyboard.chevron.compact.down" : "delete.backward", action: {
                    if (!focusState) {
                        text = ""
                    }
                    focusState = !focusState
                })
                .labelStyle(.iconOnly)
                .foregroundStyle(focusState ? Color.accentColor : Color.secondary)
                .opacity( focusState || !text.isEmpty ? 0.5 : 0)
                .animation(.easeInOut(duration: 0.15), value: focusState && !text.isEmpty)
                .contentTransition(.symbolEffect(.replace))
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10.0)
                    .strokeBorder(Color.secondary, lineWidth: 1)
                    .background {
                        RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemBackground))
                    }
                    .shadow(
                        color: focusState ? Color.accentColor : Color.clear,
                        radius: focusState ? 3 : 0
                    )
                    .animation(Animation.easeInOut(duration: 0.25), value: focusState)
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
            withAnimation {
                focusState = false
            }
            
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
