//
//  Logger+subsystem.swift
//  Tristy
//
//  Created by Frank Anderson on 6/13/25.
//

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let focus = Logger(subsystem: subsystem, category: "focus")
}
        
