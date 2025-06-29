//
//  CaptionedListRow.swift
//  Tristy
//
//  Created by Frank Anderson on 6/15/25.
//

import SwiftUI

struct CaptionedListRow<C: View, L: View>: View {
    
    init(
        caption: String,
        @ViewBuilder content: (() -> C)
    ) where L == Text {
        self.init(content: content) {
            Text(caption)
        }
    }
    
    init(content: (() -> C), caption: (() -> L)) {
        self.content = content()
        self.caption = caption()
    }
    
    var content: C
    var caption: L
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
            caption
                .font(.caption)
                .foregroundStyle(.secondary)
            
        }
    }
}

