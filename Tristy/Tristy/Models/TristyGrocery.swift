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

struct TristyGrocery: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    private(set) public var title: String
    private(set) public var completed: Bool = false
    private(set) public var groupId: String?
    private(set) public var userId: String?
    private(set) public var tags: [TristyTag] = []
    
    init(title: String, tags: [TristyTag]) {
        self.id = UUID().description
        self.title = title
        self.tags = tags
        self.completed = false
        self.groupId = GroceryRepository.shared.groupId
        self.userId = GroceryRepository.shared.userId
    }
    
    mutating func setCompleted(_ value: Bool? = nil) {
        if let v = value {
            self.completed = v
        } else {
            self.completed.toggle()
        }
    }
    
    mutating func setGroupId(_ groupId: String?) {
        self.groupId = groupId
    }
    
    mutating func setUserId(_ userId: String?) {
        self.userId = userId
    }
    
    mutating func setTitle(_ title: String) {
        self.title = title
    }
    
    mutating func remove(tag: TristyTag) {
        tags.removeAll { $0.id == tag.id }
    }
}

#if DEBUG
let examples = (1...10).map { i in
    TristyGrocery(title: "grocery: #\(i)", tags: [])
}
#endif
