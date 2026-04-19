//
//  IconTintLabelStyle.swift
//  Tristy
//
//  Created by Frank Anderson on 6/13/25.
//

import SwiftUI

struct IconTintLabelStyle: LabelStyle {

    var iconColor: Color
    var textColor: Color
    
    @State var height: CGFloat = 0

    func makeBody(
        configuration: Configuration
    ) -> some View {
        Label(
            title: {
                configuration.title.foregroundStyle(textColor)
                    .readSize { updateHeight(with: $0.height) }
                    .frame(height: height)
            },
            icon: {
                configuration.icon.foregroundStyle(iconColor)
                    .readSize { updateHeight(with: $0.height) }
                    .frame(height: height)
            }
        )
    }
    
    func updateHeight(with viewHeight: CGFloat) {
        self.height = max(self.height, viewHeight)
    }
}

extension LabelStyle where Self == IconTintLabelStyle {
    static func tintedIcon(icon iconColor: Color = .accentColor, text textColor: Color = .primary) -> Self {
        .init(iconColor: iconColor, textColor: textColor)
    }
    
    static func tintedIcon(_ iconColor: Color = .accentColor) -> Self {
        .init(iconColor: iconColor, textColor: .primary)
    }
}
