//
//  IconActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/19/25.
//

import SwiftUI

struct IconActions: View {
    
    @AppStorage(Settings.Icons.key) var icons = Settings.Icons.defaultValue
    
    let message = """
        Tap on the icons to change which ones are shown in the Shopping List.
        """
    
    @ViewBuilder
    func iconChoices(index: Int) -> some View {
        
        let selection = Binding(
            get: { icons[index] },
            set: { newValue in
                withAnimation { icons[index] = newValue }
            }
        )
        
        let availableChoices = Settings.Icons.Icon.allCases.filter {
            $0 == .none || $0 == icons[index] || !icons.contains($0)
        }
        
        Menu {
            Picker(selection: selection) {
                ForEach(availableChoices) { icon in
                    Label(icon.name, systemImage: icon.symbolName)
                        .tag(icon)
                }
            } label: {
                icons[index].correspondingPreviewView()
            }
        } label: {
            icons[index].correspondingPreviewView()
        }
    }
    
    var sampleRow: some View {
        HStack {
            Image(systemName: Symbols.complete)
                .symbolVariant(.circle)
                .font(.system(.title3))
                .foregroundStyle(.accent)
            
            Text("Sample grocery")
            
            Spacer()
            
            ForEach(0..<icons.count, id: \.self) { index in
                iconChoices(index: index)
                    .imageScale(.small)
            }
            
        }
        .frame(height: 24)
        .padding(15)
        .background(
            Color(uiColor: .systemGroupedBackground),
            in: .containerRelative
        )
    }
    
    var hasSetIcons: Bool {
        Settings.Icons.defaultValue != icons
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                sampleRow
                    .contentTransition(.symbolEffect(.replace))
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } header: {
            HStack {
                Text("Icons")
                Spacer()
                
                if hasSetIcons {
                    Button("Reset", systemImage: Symbols.reset) {
                        withAnimation {
                            icons = Settings.Icons.defaultValue
                        }
                    }
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.secondary)
                        .transition(.scale)
                }
            }
            .frame(height: 24)
            .animation(.easeInOut, value: hasSetIcons)
        }

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Form {
        IconActions()
    }
}
