//
//  GroupService.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import Firebase

struct K {
    static let groupIdKey = "UserId"
}

class GroupService: ObservableObject {
    @Published var groupId: String
    
    static let shared = GroupService.init()
    
    var hasGroupId: Bool {
        return !groupId.isEmpty
    }
    
    // Get the groupId if it exists
    // Use this id to write groceries to the database
    private init() {
        self.groupId = GroupService.findGroupId()
    }
    
    static func findGroupId() -> String {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: K.groupIdKey) as? String ?? ""
    }
    
    func setGroupId(id: String) {
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: K.groupIdKey)
        groupId = GroupService.findGroupId()
    }
}
