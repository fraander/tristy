//
//  TristyTag.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI

struct TristyTag: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var groupId: String?
    var userId: String?
}

#if DEBUG
let tagExamples = (1...10).map { i in
    TristyTag(title: "grocery: #\(i)")
}
#endif
