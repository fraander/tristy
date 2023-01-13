//
//  Color+backgroundColors.swift
//  Tristy
//
//  Created by Frank Anderson on 11/23/22.
//

import SwiftUI

public extension Color {
    
    // Add background colors for access like in UIKit
#if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
#else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
#endif
}
