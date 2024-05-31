//
//  Bool+Comparable.swift
//  Tristy
//
//  Created by Frank Anderson on 5/31/24.
//

import Foundation

extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
