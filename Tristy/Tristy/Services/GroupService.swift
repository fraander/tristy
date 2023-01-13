//
//  GroupService.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import Firebase

/// Hold onto groupId locally
class GroupService: ObservableObject {
    @Published var groupId: String
    private static let groupIdKey = "UserId"
    
    static let shared = GroupService.init()
    
    var hasGroupId: Bool {
        return !groupId.isEmpty
    }
    
    // Get the groupId if it exists
    // Use this id to write groceries to the database
    private init() {
        self.groupId = GroupService.findGroupId()
    }
    
    /// check UserDefaults for the groupId
    /// - Returns: given groupId or "" if none is found
    static func findGroupId() -> String {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: groupIdKey) as? String ?? ""
    }
    
    /// Write groupId to userDefaults
    /// - Parameter id: the id to write
    func setGroupId(id: String) {
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: GroupService.groupIdKey)
        groupId = GroupService.findGroupId()
    }
}
