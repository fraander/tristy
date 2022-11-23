//
//  GroupSettingsView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import SwiftUI

struct GroupSettingsView: View {
    struct AlertString: Identifiable, CustomStringConvertible {
        var id = UUID()
        var message: String
        
        var description: String { message }
    }
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var groupService = GroupService.shared
    @State var groupIdBeforeSet = ""
    @State var showAlert: AlertString?
    
    var body: some View {
        NavigationStack {
            VStack {
                GroupBox {
                    VStack(spacing: 12) {
                        Text("Group ID: ")
                            .font(.system(.headline, design: .rounded))
                        + Text("\(groupService.groupId.isEmpty ? "" : groupService.groupId)")
                            .font(.system(.headline, design: .monospaced))
                        
                        Group {
                            Text("Type in the same ")
                            + Text("Group ID")
                            + Text(" as your other group members in order to share a list with them.")
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                        
                        
                        TextField("groupId", text: $groupIdBeforeSet)
                            .onSubmit {
                                commitAction()
                            }
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 10)
    #if os(iOS)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
    #endif
                        Button("Set ID", action: commitAction)
                            .bold()
                            .buttonStyle(.bordered)
                            .tint(.accentColor)
                    }
                }
                .padding(.horizontal, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: commitAction)
                }
            }
            .alert(item: $showAlert) { Alert(title: Text($0.message)) }
        }
    }
    
    func commitAction() {
        if !groupIdBeforeSet.isEmpty {
            groupService.setGroupId(id: groupIdBeforeSet)
            dismiss()
        } else if groupService.groupId.isEmpty {
            showAlert = AlertString(message: "Group ID cannot be empty.")
        } else {
            dismiss()
        }
    }
}

struct GroupSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView()
    }
}
