//
//  GroupViewModel.swift
//  Tristy
//
//  Created by Frank Anderson on 10/24/22.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class GroupViewModel: ObservableObject {
    private let store = Firestore.firestore()
    private let groupPath: String = "groups"
    
    @Published var groupCode = ""
    @Published var groups: [TristyGroup] = []
    
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
