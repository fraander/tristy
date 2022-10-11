//
//  GroceryListViewModel.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Combine

class GroceryListViewModel: ObservableObject {
    @Published var groceryRepository = GroceryRepository()
    @Published var groceryVMs: [GroceryViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ listOfVM: [GroceryViewModel]) {
        self.groceryVMs = listOfVM
    }
    
    init() {
        groceryRepository.$groceries
            .map { groceries in
                groceries.map(GroceryViewModel.init)
            }
            .assign(to: \.groceryVMs, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ grocery: Grocery) {
        groceryRepository.add(grocery)
    }
}
