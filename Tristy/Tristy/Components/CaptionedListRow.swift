//
//  CaptionedListRow.swift
//  Tristy
//
//  Created by Frank Anderson on 6/15/25.
//

import SwiftUI

struct CaptionedListRow<Content: View>: View {
    
    var content: Content
    var caption: String
    
    init(caption: String, @ViewBuilder content: (() -> Content)) {
        self.content = content()
        self.caption = caption
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
            Text(caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}


