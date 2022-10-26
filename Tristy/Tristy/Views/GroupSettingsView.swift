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
                
        TextField("groupId", text: $groupIdBeforeSet)
            .onSubmit {
                commitAction()
            }
        #if os(iOS)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        #endif
        
        Button("Cancel", role: .cancel) {}
        Button("Done", action: commitAction)
    }
    
    func commitAction() {
        if !groupIdBeforeSet.isEmpty {
            groupService.setGroupId(id: groupIdBeforeSet)
        }
    }
}

struct GroupSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView()
    }
}
