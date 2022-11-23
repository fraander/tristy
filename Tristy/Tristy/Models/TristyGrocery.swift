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
    private(set) public var tagIds: [String?] = []
    
    init(title: String, tags: [TristyTag]) {
        self.id = UUID().description
        self.title = title
        self.tagIds = tags.map({ tagObject in
            GroceryRepository.shared.tags.first(where: {tagObject.id == $0.id})?.id
        })
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
        tagIds.removeAll { $0 == tag.id }
    }
}

#if DEBUG
let examples = (1...10).map { i in
    TristyGrocery(title: "grocery: #\(i)", tags: [])
}
#endif
