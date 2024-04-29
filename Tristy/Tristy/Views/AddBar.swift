//
//  AddBar.swift
//  Tristy
//
//  Created by Frank Anderson on 4/28/24.
//

import SwiftUI

struct AddBar: View {
    
    @State var text = ""
    @Environment(\.modelContext) var modelContext
    @FocusState var focusState: Focus?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        addGrocery(title: text)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(focusState == .addField ? Color.accentColor : Color.secondary)
                    
                    TextField("Add item...", text: $text)
                        .focused($focusState, equals: .addField)
                        .onSubmit {
                            addGrocery(title: text)
                        }
                        .submitLabel(.done)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(Color.secondary, lineWidth: 1)
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemBackground))
                        }
                        .shadow(
                            color: focusState == .addField ? Color.accentColor : Color.clear,
                            radius: focusState == .addField ? 3 : 0
                        )
                        .animation(Animation.easeInOut(duration: 0.25), value: focusState)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Functions
    private func addGrocery(title: String) {
        if (!text.isEmpty) {
            let grocery = Grocery(title: title)
            modelContext.insert(grocery)
            text = ""
            withAnimation {
                focusState = Focus.none
            }
        }
    }
}

#Preview {
    AddBar()
}
