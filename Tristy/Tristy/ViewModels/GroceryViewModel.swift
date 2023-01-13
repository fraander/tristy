//
//  GroceryViewModel.swift
//  Tristy
//
//  Created by Frank Anderson on 1/13/23.
//

import SwiftUI

/// Represents the view model for a GroceryView
class GroceryViewModel: ObservableObject {
    
    private let repo = GroceryRepository.shared
    @Published var grocery: TristyGrocery {
        // when the grocery is updated, update the value inside the repository
        didSet {
            // could do some change verification / checking here if needed
            
            repo.update(grocery)
        }
    }
    
    /// Create the view model for the given grocery
    /// - Parameter grocery: the grocery to create the view model for
    init(grocery: TristyGrocery) {
        self.grocery = grocery
    }
    
    /// Change the tag's title
    /// - Parameter title: title of the tag
    public func setTitle(_ title: String) {
        grocery.setTitle(title)
    }
    
    /// Set completion status to the given value; if none if provided set to false/nil
    /// - Parameter value: the new completion status
    public func setCompleted(_ value: Bool? = nil) {
        grocery.setCompleted(value)
    }
    
    /// Remove the given tag from the repository
    /// - Parameter tag: the tag to remove
    public func remove(tag: TristyTag) {
        grocery.remove(tag: tag)
        repo.update(grocery)
    }
}
