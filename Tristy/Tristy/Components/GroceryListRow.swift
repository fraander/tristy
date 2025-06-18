//
//  GroceryView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/12/25.
//

import Foundation
import SwiftUI
import SwiftData

struct GroceryListRow: View {
    
    @Environment(\.groceryList) var list
    @Environment(\.selectedGroceries) var selectedGroceries
    @Environment(\.modelContext) var modelContext
    @Environment(AddBarStore.self) var abStore
    @Environment(Router.self) var router
    var grocery: Grocery
    
    @State var newTitle = ""
    @State var initialValue = ""
    
    @FocusState var focus: FocusOption?
    
    // button with checkmark to show tag is complete/incomplete
    var checkboxView: some View {
        
        Button("Complete grocery", systemImage: Symbols.complete) { grocery.toggleCompleted()
        }
        .symbolToggleEffect(grocery.isCompleted, activeVariant: .circle.fill, inactiveVariant: .circle)
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .foregroundColor(grocery.isCompleted ? .mint : .accentColor)
        .animation(.easeOut(duration: 0.25), value: grocery.completed)
        .font(.system(.title2))
    }
    
    // line to strikethrough tag title (draw in/out instead of fade with normal .strikethrough() )
    var strikethroughView: some View {
        HStack {
            Capsule()
                .frame(maxWidth: grocery.isCompleted ? .infinity : 0, maxHeight: 2, alignment: .leading)
                .opacity(grocery.isCompleted ? 1 : 0)
            Spacer()
        }
    }
    
    var iconsView: some View {
        HStack {
            let quantityCondition = grocery.quantityOrEmpty != 0
            if (quantityCondition) {
                Text("\(formatAsMixedNumber(grocery.quantityOrEmpty)) \(grocery.unitOrEmpty)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle( Color.primary.mix(with: .secondary, by: 0.75) )
            }
            
            if (grocery.isUncertain) {
                Image(systemName: Symbols.uncertain)
                    .symbolToggleEffect(grocery.isUncertain)
                    .foregroundStyle(.indigo)
            }
            
            let notesCondition = !grocery.notesOrEmpty.isEmpty
            if (notesCondition) {
                Image(systemName: Symbols.notes)
                    .symbolToggleEffect(notesCondition)
                    .foregroundStyle(.yellow)
            }
            
            let importanceCondition = grocery.importanceEnum != .none
            if (importanceCondition) {
                Image(systemName: grocery.importanceEnum.symbolName)
                    .foregroundStyle(grocery.importanceEnum.color)
            }
            
            if (grocery.isPinned) {
                Image(systemName: Symbols.pinned)
                    .symbolToggleEffect(grocery.isPinned)
                    .foregroundStyle(.orange)
            }
        }
    }
    
    // show text or textfield depending on completion state
    var textView: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $newTitle, onEditingChanged: { _ in
                if (newTitle.isEmpty) { // check not left empty
                    newTitle = initialValue // reset to initial value so not blank
                } else { // update
                    grocery.title = newTitle // set the title
                    initialValue = grocery.titleOrEmpty // set new initial value checkpoint
                }
            })
            .lineLimit(1)
            .focused($focus, equals: .grocery(grocery.id))
            .onChange(of: focus, { oldValue, newValue in
                router.updateFocus(from: oldValue, to: newValue, for: .grocery(grocery.id))
            })
            .onChange(of: router.focus, { focus = $1 })
            .font(.system(.body, design: .rounded))
            
            Text(newTitle)
                .opacity(0.0)
                .padding(.trailing, 10)
                .lineLimit(1)
                .overlay { strikethroughView }
                .animation(.easeOut(duration: 0.25), value: grocery.completed)
            
        }
        .foregroundColor(grocery.isCompleted ? .secondary : .primary)
    }
    
    var groceryListButtons: some View {
        Group {
            ForEach(GroceryList.allCases) { gl in
                if list != gl {
                    Button("Move to \(gl.name)", systemImage: gl.symbolName) {
                        grocery.setList(gl)
                    }
                    .tint(gl.color)
                }
            }
        }
    }
    
    var infoButton: some View {
        Button("Info", systemImage: Symbols.info) {
            router.presentSheet(TristySheet.groceryInfo(grocery))
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                if list == .active {
                    HStack {
                        checkboxView
                        textView
                    }
                } else {
                    Text(grocery.titleOrEmpty)
                }
                
                if list == .active {
                    Spacer()
                    iconsView
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) { groceryListButtons }
        .swipeActions(edge: .leading, allowsFullSwipe: true) { infoButton }
        .contextMenu {
            Section { groceryListButtons }
            Section { infoButton }
        }
        .font(.system(.body, design: .rounded))
        .task {
            // track value before editing
            initialValue = grocery.titleOrEmpty
            newTitle = grocery.titleOrEmpty
        }
        .onChange(of: grocery.titleOrEmpty) { oldValue, newValue in
            initialValue = grocery.titleOrEmpty
            newTitle = grocery.titleOrEmpty
        }
    }

    func formatAsMixedNumber(_ value: Double) -> String {
        let whole = Int(value)
        let fractional = value - Double(whole)
        
        if abs(fractional) < 0.001 { return "\(whole)" }
        
        // Common denominators to check
        let denominators = [2, 3, 4, 5, 6, 8]
        
        for denom in denominators {
            let num = Int(round(fractional * Double(denom)))
            if abs(fractional - Double(num) / Double(denom)) < 0.001 {
                let gcd = gcd(abs(num), denom)
                let simplifiedNum = num / gcd
                let simplifiedDenom = denom / gcd
                
                let fractionStr = "\(simplifiedNum)/\(simplifiedDenom)"
                return whole == 0 ? fractionStr : "\(whole) \(fractionStr)"
            }
        }
        
        return String(format: "%.3f", value) // fallback to decimal
    }

    func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
    }
}
