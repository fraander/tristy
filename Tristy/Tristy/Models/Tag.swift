//
//  Tag.swift
//  Tristy
//
//  Created by Frank Anderson on 10/11/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI

struct Tag: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var userId: String?
}

#if DEBUG
let exampleTags = (1...10).map {
    Tag(title: "tag #\($0)")
}
#endif
