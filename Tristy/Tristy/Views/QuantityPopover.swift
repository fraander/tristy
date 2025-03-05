//
//  QuantityPopover.swift
//  Tristy
//
//  Created by Frank Anderson on 1/17/25.
//

import SwiftUI
import Combine

struct QuantityPopover: View {
    @Binding var grocery: Grocery?
    @State private var numberString = ""
    
    var body: some View {
        TextField("Quantity", text: $numberString)
            .textFieldStyle(.roundedBorder)
            .numbersOnly($numberString, includeDecimal: true)
            .frame(width: 200)
            .onChange(of: numberString) { oldValue, newValue in
                if let value = Double(numberString) {
                    grocery?.quantity = value
                }
            }
            .onChange(of: grocery?.id) {
                if let double = grocery?.quantity {
                    if (double > 0) {
                        let value = String(double)
                        numberString = value
                    }
                }
            }
            .onSubmit {
                if (numberString == "") {
                    grocery?.quantity = 0
                }
            }
    }
}

#Preview {
    QuantityPopover(grocery: .constant(Grocery(title: "testing")))
}


struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    var includeDecimal: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers += decimalSeparator
                }
                if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}
