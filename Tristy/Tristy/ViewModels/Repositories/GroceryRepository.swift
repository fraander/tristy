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
    var userId = ""
    private let authenticationService = AuthenticationService()
    private var cancellables: Set<AnyCancellable> = []
    
    private let path: String = "groceries"
    private let store = Firestore.firestore()
    
    @Published var groceries: [Grocery] = []
    
    init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.get()
            }
            .store(in: &cancellables)
    }
    
    func get() {
        store.collection(path)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting cards: \(error.localizedDescription)")
                    return
                }
                
                self.groceries = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Grocery.self)
                } ?? []
            }
    }
    
    func add(_ grocery: Grocery) {
        do {
            var newGrocery = grocery
            newGrocery.userId = userId
            _ = try store.collection(path).addDocument(from: newGrocery)
        } catch {
            fatalError("Unable to add grocery: \(error.localizedDescription)")
        }
    }
    
    func update(_ grocery: Grocery) {
        guard let groceryId = grocery.id else { return }
        
        do {
            try store.collection(path).document(groceryId).setData(from: grocery)
        } catch {
            fatalError("Unable to update grocery: \(error.localizedDescription).")
        }
    }
    
    func remove(_ grocery: Grocery) {
        guard let groceryId = grocery.id else { return }
        
        store.collection(path).document(groceryId).delete { error in
            if let error = error {
                print("Unable to remove grocery: \(error.localizedDescription)")
            }
        }
    }
}
