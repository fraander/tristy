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
    static var shared: GroceryRepository = .init()
    
    @Published var userId = ""
    @Published var groupId = ""
    private let authenticationService = AuthenticationService()
    private let groupService = GroupService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    private let groceryPath: String = "groceries"
    private let tagPath: String = "tags"
    private let store = Firestore.firestore()
    
    @Published var groceries: [TristyGrocery] = []
    @Published var tags: [TristyTag] = []
    
    // MARK: - Initializer
    
    private init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.getGroceries()
                self?.getTags()
            }
            .store(in: &cancellables)
        
        groupService.$groupId
            .assign(to: \.groupId, on: self)
            .store(in: &cancellables)
        
        groupService.$groupId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.getGroceries()
                self?.getTags()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Gets
    
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
    
    func getTags() {
        store.collection(tagPath)
            .whereField("groupId", isEqualTo: groupId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting tags: \(error.localizedDescription)")
                    return
                }
                
                self.tags = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: TristyTag.self)
                } ?? []
            }
    }
    
    // MARK: - Grocery Functions

    func add(_ grocery: TristyGrocery) {
        do {
            var newGrocery = grocery
            newGrocery.setGroupId(groupId)
            newGrocery.setUserId(userId)
            _ = try store.collection(groceryPath).addDocument(from: newGrocery)
        } catch {
            fatalError("Unable to add grocery: \(error.localizedDescription)")
        }
    }
    
    func update(_ grocery: TristyGrocery) {
        guard let groceryId = grocery.id else { return }
        
        do {
            try store.collection(groceryPath).document(groceryId).setData(from: grocery)
        } catch {
            fatalError("Unable to update grocery: \(error.localizedDescription).")
        }
    }
    
    func remove(_ grocery: TristyGrocery) {
        guard let groceryId = grocery.id else { return }
        
        store.collection(groceryPath).document(groceryId).delete { error in
            if let error = error {
                print("Unable to remove grocery: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Tag Functions
    
    func add(_ tag: TristyTag) {
        do {
            var newTag = tag
            newTag.groupId = groupId
            newTag.userId = userId
            _ = try store.collection(tagPath).addDocument(from: newTag)
        } catch {
            fatalError("Unable to add tag: \(error.localizedDescription)")
        }
    }
    
    func update(_ tag: TristyTag) {
        guard let tagId = tag.id else { return }
        
        do {
            try store.collection(tagPath).document(tagId).setData(from: tag)
        } catch {
            fatalError("Unable to update grocery: \(error.localizedDescription).")
        }
    }
    
    func remove(_ tag: TristyTag) {
        guard let tagId = tag.id else { return }
        
        store.collection(tagPath).document(tagId).delete { error in
            if let error = error {
                print("Unable to remove grocery: \(error.localizedDescription)")
            }
        }
    }
}
