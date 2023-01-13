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

/// Represents an item in the grocery list
struct TristyGrocery: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    private(set) public var title: String
    private(set) public var completed: Bool = false
    private(set) public var groupId: String?
    private(set) public var userId: String?
    private(set) public var tags: [TristyTag]
    
    /// Create an item
    /// - Parameters:
    ///   - title: title of the item
    ///   - tags: its tags
    init(title: String, tags: [TristyTag]) {
        self.id = UUID().description
        self.title = title
        self.tags = tags
        self.completed = false
        self.groupId = GroceryRepository.shared.groupId
        self.userId = GroceryRepository.shared.userId
    }
    
    /// Set the item to completed or incomplete
    /// - Parameter value: completion status to set
    mutating func setCompleted(_ value: Bool? = nil) {
        if let v = value {
            self.completed = v
        } else {
            self.completed.toggle()
        }
    }
    
    /// Set the item's group ownership
    /// - Parameter groupId: id of group to own
    mutating func setGroupId(_ groupId: String?) {
        self.groupId = groupId
    }
    
    /// Set the item's user ownership
    /// - Parameter userId: the user owner's id
    mutating func setUserId(_ userId: String?) {
        self.userId = userId
    }
    
    /// Set the item's title
    /// - Parameter title: the title to set
    mutating func setTitle(_ title: String) {
        self.title = title
    }
    
    /// Remove the given tag
    /// - Parameter tag: tag to remove
    mutating func remove(tag: TristyTag) {
        tags.removeAll {
            return $0.title == tag.title && $0.groupId == tag.groupId}
    }
}

#if DEBUG
let examples = (1...10).map { i in
    TristyGrocery(title: "grocery: #\(i)", tags: [])
}
#endif
