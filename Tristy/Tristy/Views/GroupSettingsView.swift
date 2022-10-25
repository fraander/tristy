//
//  GroupSettingsView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import SwiftUI

struct GroupSettingsView: View {
    @ObservedObject var groupService = GroupService.shared
    @State var groupIdBeforeSet = ""
    
    var body: some View {
        Text("Group ID: \(groupService.groupId)")
        
        TextField("groupId", text: $groupIdBeforeSet)
            .onSubmit {
                if !groupIdBeforeSet.isEmpty {
                    groupService.setGroupId(id: groupIdBeforeSet)
                }
            }
    }
}

struct GroupSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView()
    }
}
