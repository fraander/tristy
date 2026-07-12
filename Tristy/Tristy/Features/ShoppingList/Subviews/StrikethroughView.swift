//  StrikethroughView.swift
//  Tristy
//
//  Created by refactor.

import SwiftUI

struct StrikethroughView: View {
    let isCompleted: Bool
    
    var body: some View {
        HStack {
            Capsule()
                .frame(maxWidth: isCompleted ? .infinity : 0, maxHeight: 2, alignment: .leading)
                .opacity(isCompleted ? 1 : 0)
            Spacer()
        }
    }
}
