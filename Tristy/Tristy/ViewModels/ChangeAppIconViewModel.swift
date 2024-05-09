//
//  ChangeAppIconViewModel.swift
//  Tristy
//
//  Created by Frank Anderson on 5/7/24.
//

#if os(iOS)
import Foundation
import UIKit

final class ChangeAppIconViewModel: ObservableObject {


    @Published private(set) var selectedAppIcon: AppIcon

    init() {
        if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
            selectedAppIcon = appIcon
        } else {
            selectedAppIcon = .check
        }
    }

    func updateAppIcon(to icon: AppIcon) {
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                /// No need to update since we're already using this icon.
                return
            }
            
            UIApplication.shared.setAlternateIconName(icon.iconName) { error in
                self.selectedAppIcon = previousAppIcon
            }
        }
    }
}

#endif
