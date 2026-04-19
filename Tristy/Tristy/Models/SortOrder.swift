import Foundation

// Protocol that requires a sortOrder property
public protocol SortOrderable {
    var sortOrder: Double { get set }
}

// Service for computing sort orders and rebalancing
public struct SortOrderService<T: SortOrderable> {
    
    
    // Compute a midpoint between two sort orders
    public static func midpoint(between first: Double, and second: Double) -> Double {
        return (first + second) / 2.0
    }

    /// Compute a sortOrder for inserting an item at a target index within an already-sorted array.
    /// - Parameters:
    ///   - index: The destination index.
    ///   - items: The items sorted ascending by `sortOrder`.
    ///   - defaultStep: The step to use when inserting at ends. Defaults to 1.0.
    static func sortOrderForInsert(at index: Int, in items: [T], defaultStep: Double = 1.0, get: (T) -> Double) -> Double {
        if items.isEmpty { return 0 }
        if index <= 0 {
            // Before first
            let first = get(items.first!)
            return first - defaultStep
        } else if index >= items.count {
            // After last
            let last = get(items.last!)
            return last + defaultStep
        } else {
            let prev = get(items[index - 1])
            let next = get(items[index])
            return midpoint(between: prev, and: next)
        }
    }

    /// Rebalance sort orders so they are roughly integral steps apart.
    /// - Parameters:
    ///   - items: The items sorted ascending by `sortOrder`.
    ///   - start: Starting value for the rebalance sequence.
    ///   - step: Step between subsequent items.
    static func rebalance(items: inout [T], start: Double = 0, step: Double = 1.0, set: (inout T, Double) -> Void) {
        var current = start
        for i in 0..<items.count {
            set(&items[i], current)
            current += step
        }
    }
    
    
    // Compute a sortOrder that comes before the first element's sortOrder
    public static func sortOrderBefore(_ firstSortOrder: Double) -> Double {
        return firstSortOrder - 1.0
    }
    
    // Compute a sortOrder that comes after the last element's sortOrder
    public static func sortOrderAfter(_ lastSortOrder: Double) -> Double {
        return lastSortOrder + 1.0
    }
    
    // Compute a sortOrder between two existing sortOrders
    public static func sortOrder(between firstSortOrder: Double, and secondSortOrder: Double) -> Double {
        return midpoint(between: firstSortOrder, and: secondSortOrder)
    }
    
    // Compute a sortOrder to place a new element at the end of the list
    public static func sortOrderForNewLast(_ existing: [T]) -> Double {
        guard let maxSortOrder = existing.map({ $0.sortOrder }).max() else {
            return 0.0
        }
        return sortOrderAfter(maxSortOrder)
    }
    
    // Compute a sortOrder to place a new element at the beginning of the list
    public static func sortOrderForNewFirst(_ existing: [T]) -> Double {
        guard let minSortOrder = existing.map({ $0.sortOrder }).min() else {
            return 0.0
        }
        return sortOrderBefore(minSortOrder)
    }
    
    // Compute a sortOrder to place a new element between two elements
    public static func sortOrderForNewBetween(_ before: T, and after: T) -> Double {
        return sortOrder(between: before.sortOrder, and: after.sortOrder)
    }
    
    // Rebalance the sortOrder values in the array so they are spaced evenly starting from 0
    // with increments of 1.0. Returns a new array with updated sortOrders.
    public static func rebalance(_ array: [T]) -> [T] {
        guard !array.isEmpty else { return [] }
        
        // Sort by current sortOrder
        let sorted = array.sorted { $0.sortOrder < $1.sortOrder }
        
        // Create new elements with balanced sortOrder values
        var balanced: [T] = []
        for (index, element) in sorted.enumerated() {
            var copy = element
            copy.sortOrder = Double(index)
            balanced.append(copy)
        }
        return balanced
    }
}
