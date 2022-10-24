//
//  GroupView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/22/22.
//

import SwiftUI

// TODO: move group ids to each grocery item
// TODO: show settings on homepage to allow for setup
// TODO: test!!

struct GroupView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var groupViewModel: GroupViewModel
    @ObservedObject var groceryRepository: GroceryRepository
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Find group") {
                    TextField("Group code", text: $groupViewModel.groupCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .textCase(.lowercase)
                        .onSubmit {
                            if !groupViewModel.groupCode.isEmpty {
                                groupViewModel.fetchData()
                                groupViewModel.groupCode = ""
                            }
                        }
                }
                
                if (!groupViewModel.groups.isEmpty) {
                    Section("Groups") {
                        List(groupViewModel.groups) { group in
                            
                            HStack {
                                Text(group.groupId)
                                
                                Spacer()
                                
                                Button {
                                    groceryRepository.groupId = group.groupId // TODO: fix publishing from within
                                    // TODO: write to userdefaults and then get from userdefaults on launch
                                    
                                    // TODO: simplify architecture of app (possible rewrite)
                                } label: {
                                    Text("Join")
                                }

                            }
                            
                            // TODO: add "join" button that changes id to groupID and stores in UserDefaults.
                            // TODO: when writing a code, use auth value and value in userdefaults.
                        }
                    }
                }
            }
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(groupViewModel: GroupViewModel(), groceryRepository: GroceryRepository())
    }
}
