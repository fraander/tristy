//
//  GroceryRepository.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class GroceryRepository: ObservableObject {
    @Published var userId = ""
    @Published var groupId = ""
    private let authenticationService = AuthenticationService()
    private let groupService = GroupService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    private let groceryPath: String = "groceries"
    private let store = Firestore.firestore()
    
    @Published var groceries: [TristyGrocery] = []
    
    init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        groupService.$groupId
            .assign(to: \.groupId, on: self)
            .store(in: &cancellables)
        
        groupService.$groupId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.getGroceries()
            }
            .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.getGroceries()
            }
            .store(in: &cancellables)
    }
    
    func getGroceries() {
        store.collection(groceryPath)
            .whereField("groupId", isEqualTo: groupId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting groceries: \(error.localizedDescription)")
                    return
                }
                
                self.groceries = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: TristyGrocery.self)
                } ?? []
            }
    }
    
    func addGroceries(_ grocery: TristyGrocery) {
        do {
            var newGrocery = grocery
            newGrocery.groupId = groupId
            newGrocery.userId = userId
            _ = try store.collection(groceryPath).addDocument(from: newGrocery)
        } catch {
            fatalError("Unable to add grocery: \(error.localizedDescription)")
        }
    }
    
    func updateGroceries(_ grocery: TristyGrocery) {
        guard let groceryId = grocery.id else { return }
        
        do {
            try store.collection(groceryPath).document(groceryId).setData(from: grocery)
        } catch {
            fatalError("Unable to update grocery: \(error.localizedDescription).")
        }
    }
    
    func removeGroceries(_ grocery: TristyGrocery) {
        guard let groceryId = grocery.id else { return }
        
        store.collection(groceryPath).document(groceryId).delete { error in
            if let error = error {
                print("Unable to remove grocery: \(error.localizedDescription)")
            }
        }
    }
}
