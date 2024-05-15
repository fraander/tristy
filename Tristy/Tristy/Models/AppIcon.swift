//
//  AppIcons.swift
//  Tristy
//
//  Created by Frank Anderson on 5/7/24.
//

#if os(iOS)
import Foundation
import UIKit

enum AppIcon: String, CaseIterable, Identifiable {
//    case breadWhiteGlow = "BreadWhiteGlow"
    case breadWhite = "BreadWhite"
//    case cartWhiteGlow = "CartWhiteGlow"
    case cartWhite = "CartWhite"
    case checkoutlined = "CheckOutlined"
    case check = "Check"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .check:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
//        case .breadWhiteGlow:
//            "Bread (Glow)"
        case .breadWhite:
            "Bread"
//        case .cartWhiteGlow:
//            "Cart (Glow)"
        case .cartWhite:
            "Cart"
        case .checkoutlined:
            "Check (Outlined)"
        case .check:
            "Check"
        }
    }

    var preview: UIImage {
        UIImage(named: rawValue + "-Preview") ?? UIImage()
    }
}

#endif
