//
//  StoreActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/29/25.
//

import SwiftUI
import SwiftData
import SymbolPicker

struct StoreEditorView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var name: String = ""
    @State var symbol: String = ""
    @State var color: Color = .blue
    
    var body: some View {
        
    }
}
struct StoreBrowserRow: View {
    
    @Namespace var namespace
    @Environment(\.modelContext) var modelContext
    @State var showEdit = false
    
    var store: GroceryStore
    
    var body: some View {
        
//        Label(
//            title: { Text(store.nameOrEmpty) },
//            icon: {
//                Image(systemName: store.symbolOrDefault)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 15, height: 15)
//                    .foregroundStyle(.white)
//                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
//                    .padding(5)
//                    .background(store.colorOrDefault.gradient, in: .rect(cornerRadius: 8))
//            }
//        )
//        .labelIconToTitleSpacing(22)
        Label(store.nameOrEmpty, systemImage: store.symbolOrDefault)
            .labelStyle(.tintedIcon(store.colorOrDefault))
        .matchedTransitionSource(id: "zoom_\(store.persistentModelID)", in: namespace)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button("Edit store", systemImage: Symbols.info) {
                showEdit = true
            }
            .tint(.gray)
            .labelStyle(.iconOnly)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete store", systemImage: "trash", role: .destructive) {
                deleteStore(store: store)
            }
            .tint(.pink)
            .labelStyle(.iconOnly)
        }
        .sheet(isPresented: $showEdit) {
            StoreAdderSheet(existingStore: store)
#if os(iOS)
                .navigationTransition(.zoom(sourceID: "zoom_\(store.persistentModelID)", in: namespace))
            #endif
        }
        
    }
    
    func deleteStore(store: GroceryStore) {
        modelContext.delete(store)
        let _ = try? modelContext.save()
    }
}

struct StoreBrowser: View {
    @Query var stores: [GroceryStore]
    
    var body: some View {
        if stores.isEmpty {
            ContentUnavailableView("", systemImage: Symbols.emptyList)
        } else {
            ForEach(stores) { store in
                StoreBrowserRow(store: store)
            }
        }
    }
}

struct StoreAdderSheet: View {
    let symbols = [ "cart", "basket", "bag", "storefront", "building.2", "house", "location", "map", "pin", "star", "leaf", "flame", "drop", "snow", "sun.max", "moon", "cloud", "bolt", "wind", "tv", "carrot", "fish", "drop.halffull", "wineglass", "cup.and.saucer", "birthday.cake", "takeoutbag.and.cup.and.straw", "refrigerator", "oven", "frying.pan", "cooktop", "scale.3d", "timer", "bell", "tag", "percent", "dollarsign.circle", "creditcard", "giftcard", "truck.box", "shippingbox", "return", "checkmark.circle", "xmark.circle", "person", "person.2", "person.3", "crown", "flag", "globe", "building.columns", "pyramid", "photo.on.rectangle.angled", "tree", "banknote", "scanner", "barcode" ]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var newTitle = ""
    @State var newSymbol = Symbols.basket
    @State var newColor: Color = SymbolColor.moro.color
    
    var iconsScroll: some View {
        // grid of symbols, choose 50ish great ones to represent different national grocery stores
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                ForEach(symbols, id: \.self) { symbol in
                    Button {
                        withAnimation {
                            newSymbol = symbol
                        }
                    } label: {
                        Image(systemName: symbol)
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                        #if os(iOS)
                            .background(Color(.systemGray6), in: .rect(cornerRadius: 8))
                        #else
                            .background(Color(nsColor: .tertiarySystemFill))
                        #endif
                            .padding(4)
                            .overlay {
                                if (newSymbol == symbol) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(newColor, lineWidth: 2)
                                        .matchedGeometryEffect(id: "highlighter", in: namespace)
                                }
                            }
                    }
                }
                .tint(.primary)
                .foregroundStyle(.primary)
            }
            .padding(.top, 10)
            .padding(.bottom, 60)
            .padding(.horizontal)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    init() {
        _newTitle = .init(initialValue: "")
        _newSymbol = .init(initialValue: Symbols.basket)
        _newColor = .init(initialValue: SymbolColor.moro.color)
    }
    
    init(
        existingStore: GroceryStore,
    ) {
        self.existingStore = existingStore
        
        _newTitle = .init(initialValue: existingStore.nameOrEmpty)
        _newSymbol = .init(initialValue: existingStore.symbolOrDefault)
        _newColor = .init(initialValue: existingStore.colorOrDefault)
    }
    
    var existingStore: GroceryStore?
    
    @Namespace var namespace
    
    var closeButton: some View {
        Button(role: .close) { dismiss() }
    }
    
    var submitButton: some View {
        Button(role: .confirm) {
            
            if existingStore == nil {
                modelContext.insert(
                    GroceryStore(
                        name: newTitle,
                        symbolName: newSymbol,
                        color: newColor
                    )
                )
            } else {
                existingStore?.updateColor(with: newColor)
                existingStore?.name = newTitle
                existingStore?.symbolName = newSymbol
            }
            
            let _ = try? modelContext.save()
            dismiss()
        }
        .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                Image(systemName: newSymbol)
                    .font(.system(size: 60))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .padding(30)
                    .background(newColor.gradient, in: .rect(cornerRadius: 20))
                    .contentTransition(.symbolEffect(.replace))
#if os(macOS)
                    .padding(.top, 40)
#endif
                
                HStack {
                    TextField("Title", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                    
                    ColorPicker("Color", selection: $newColor, supportsOpacity: false)
                        .labelsHidden()
                }
                .padding()
                .padding(.horizontal)
                .frame(maxWidth: 360)
                .padding(.bottom)
                
                Divider()
                
                iconsScroll
            }
            
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    closeButton
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    closeButton
                }
                #endif
                
                ToolbarItem(placement: .principal) {
                    Text("\(existingStore == nil ? "Add" : "Edit") Store")
                }
            
#if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    submitButton
                }
#else
                ToolbarItem(placement: .confirmationAction) {
                    submitButton
                }
#endif
            }
        }
    }
}

struct StoreAdder: View {
    @Namespace var namespace
    @State var showNewStore = false
    
    var body: some View {
        Button("Add new store", systemImage: "plus") {
            showNewStore = true
        }
        .matchedTransitionSource(id: "add", in: namespace)
        .sheet(isPresented: $showNewStore) {
            StoreAdderSheet()
                .frame(minHeight: 420)
#if os(iOS)
                .navigationTransition(.zoom(sourceID: "add", in: namespace))
            #endif
        }
    }
}

struct StoreActions: View {
    var body: some View {
        Group {
            StoreBrowser()
            StoreAdder()
        }
    }
}

#Preview(traits: .sampleData) {
    List {
        Section {
            StoreActions()
        }
    }
}
