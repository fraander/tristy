//
//  GroupView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/22/22.
//

import SwiftUI
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TristyGroup: Identifiable, Codable {
    @DocumentID var id: String?
    var groupId: String
    var users: [String]
}

// TODO: move group ids to each grocery item
// TODO: show settings on homepage to allow for setup
// TODO: test!!

class GroupViewModel: ObservableObject {
    private let store = Firestore.firestore()
    private let groupPath: String = "groups"
    
    @Published var groupCode = ""
    @Published var groups: [TristyGroup] = []
    
    func joinGroup() {
        // TODO: write group code to group db
    }
    
    func getGroups() {
        store.collection(groupPath)
            .whereField("groupId", isEqualTo: groupCode)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting groceries: \(error.localizedDescription)")
                    return
                }
                
                self.groups = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: TristyGroup.self)
                } ?? []
            }
    }
    
    func fetchData() {
        store.collection("groups").whereField("groupId", isEqualTo: groupCode).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> TristyGroup in
                let data = queryDocumentSnapshot.data()
                let groupId = data["groupId"] as? String ?? ""
                let users = data["users"] as? [String] ?? []
                
                print(groupId)
                print(users)
                
                return TristyGroup(groupId: groupId, users: users)
            }
            
            print(self.groups)
        }
    }
}

struct GroupView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var groupViewModel = GroupViewModel()
    
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
                            
                            Text(group.groupId)
                            
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
        GroupView()
    }
}
