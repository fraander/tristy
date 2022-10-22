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

struct Group: Identifiable, Codable {
    @DocumentID var id: String?
    var groupId: String
    var users: [String]
}

class GroupViewModel: ObservableObject {
    private let store = Firestore.firestore()
    private let groupPath: String = "groups"
    
    @Published var groupCode = ""
    @Published var groups: [Group] = []
    
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
                    try? document.data(as: Group.self)
                } ?? []
            }
    }
    
    func fetchData() {
        store.collection("groups").whereField("groupId", isEqualTo: groupCode).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> Group in
                let data = queryDocumentSnapshot.data()
                let groupId = data["groupId"] as? String ?? ""
                let users = data["users"] as? [String] ?? []
                
                print(groupId)
                print(users)
                
                return Group(groupId: groupId, users: users)
            }
            
            print(self.groups)
        }
    }
}

struct GroupView: View {
    @ObservedObject var groupViewModel = GroupViewModel()
    
    var body: some View {
        VStack {
            TextField("Group code", text: $groupViewModel.groupCode)
                .onSubmit {
                    groupViewModel.fetchData()
                }
            
            List(groupViewModel.groups) { group in
                Text(group.groupId)
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
