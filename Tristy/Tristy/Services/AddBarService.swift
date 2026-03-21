//
//  AddBar.swift
//  Tristy
//
//  Created by frank on 3/21/26.
//

struct AddBarService {
    static func findClosestGroceries(for title: String, in groceries: [Grocery], limit: Int = 6) -> [Grocery] {
        let searchTitle = title.lowercased()
        
        return groceries
            .compactMap { grocery -> (Grocery, Int)? in
                let groceryTitle = grocery.titleOrEmpty.lowercased()
                guard !groceryTitle.isEmpty else { return nil }
                
                var score = 0
                if groceryTitle == searchTitle { score = 100 }
                else if groceryTitle.hasPrefix(searchTitle) { score = 80 }
                else if searchTitle.hasPrefix(groceryTitle) { score = 70 }
                else if groceryTitle.contains(searchTitle) { score = 60 }
                else if searchTitle.contains(groceryTitle) { score = 50 }
                else { return nil }
                
                return (grocery, score)
            }
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { $0.0 }
    }
}
