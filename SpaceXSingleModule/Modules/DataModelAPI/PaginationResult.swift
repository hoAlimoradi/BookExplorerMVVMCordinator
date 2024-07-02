//
//  PaginationResult.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
/// Represents a paginated result containing items of type `T`.
public struct PaginationResult<T> {
    /// The array of items in the current page of results.
    public var items: [T]
    
    /// The total number of items across all pages.
    public var total: Int

    /// Initializes a new instance of `PaginationResult`.
    ///
    /// - Parameters:
    ///   - items: The array of items in the current page of results.
    ///   - total: The total number of items across all pages.
    public init(items: [T], total: Int) {
        self.items = items
        self.total = total
    }
}

 
