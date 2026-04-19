//
//  Logger+subsystem.swift
//  Tristy
//
//  Created by Frank Anderson on 6/13/25.
//

import OSLog

extension Logger {
    
    /// Property containing the bundle identifier; for convenience
    private static let subsystem = Bundle.main.bundleIdentifier!
    
    /// Related to the focus engine
    static let focus = Logger(subsystem: subsystem, category: "focus")

    /// Related to the app setup; in `View+applyEnvironment`
    static let setup = Logger(subsystem: subsystem, category: "setup")
}
        
