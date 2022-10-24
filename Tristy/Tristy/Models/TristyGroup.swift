//
//  TristyGroup.swift
//  Tristy
//
//  Created by Frank Anderson on 10/24/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TristyGroup: Identifiable, Codable {
    @DocumentID var id: String?
    var groupId: String
    var users: [String]
}
