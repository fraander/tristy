//
//  IconActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/19/25.
//

import SwiftUI

struct IconChoice: View {
    let index: Int
    @Binding var icons: [Settings.Icons.Icon]
    
    @State var showPopover = false
    
    var body: some View {
        
        let selection = Binding(
            get: { icons[index] },
            set: { newValue in
                withAnimation { icons[index] = newValue }
            }
        )
        
        let availableChoices = Settings.Icons.Icon.allCases.filter {
            $0 == .none || $0 == icons[index] || !icons.contains($0)
        }
        
#if os(iOS)
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
#elseif os(macOS)
        Button {
            showPopover.toggle()
        } label: {
            icons[index].correspondingPreviewView()
                .labelStyle(.iconOnly)
                .contentTransition(.symbolEffect)
        }
        .popover(isPresented: $showPopover) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(availableChoices) { icon in
                    Button(icon.name, systemImage: icon.symbolName) {
                        withAnimation { icons[index] = icon }
                    }
                        .buttonStyle(.plain)
                        .focusEffectDisabled()
                        .foregroundStyle(icons[index] == icon ? .white : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                        .background(icons[index] == icon ? .accent : .clear, in: .rect(cornerRadius: 15.0))
                        .padding(2)
                    
                    if icon != availableChoices.last {
                        Divider()
                    }
                }
            }
            .padding(5)
        }
#endif
    }
}

struct IconActions: View {
    
    @AppStorage(Settings.Icons.key) var icons = Settings.Icons.defaultValue
    
    let message = """
        Tap on the icons to change which ones are shown in the Shopping List.
        """
    
    var sampleRow: some View {
        
        #if os(iOS)
        let backgroundColor = Color(uiColor: .systemGroupedBackground)
        #elseif os(macOS)
        let backgroundColor = Color(nsColor: .windowBackgroundColor)
        #endif
        
        return HStack {
            Image(systemName: Symbols.complete)
                .symbolVariant(.circle)
                .font(.system(.title3))
                .foregroundStyle(.accent)
            
            Text("Sample grocery")
            
            Spacer()
            
            ForEach(0..<icons.count, id: \.self) { index in
                IconChoice(index: index, icons: $icons)
                    .imageScale(.small)
            }
            
        }
        .frame(height: 24)
        .padding(15)
        .background(
            backgroundColor,
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
    List {
        IconActions()
    }
}
