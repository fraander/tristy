//
//  GroceryViewModel.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Combine

class GroceryDetailViewModel: ObservableObject, Identifiable {
    private let groceryRepository = GroceryRepository()
    @Published var grocery: Grocery
    private var cancellables: Set<AnyCancellable> = []
    var id = ""
    
    init(grocery: Grocery) {
        self.grocery = grocery
        
        $grocery
            .compactMap {$0.id}
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func update() {
        groceryRepository.updateGroceries(grocery)
    }
    
    func remove() {
        groceryRepository.removeGroceries(grocery)
    }
}
