//
//  Grocery.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI

struct Grocery: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var completed: Bool = false
    var groupId: String?
    var userId: String?
}

#if DEBUG
let examples = (1...10).map { i in
    Grocery(title: "grocery: #\(i)")
}
#endif