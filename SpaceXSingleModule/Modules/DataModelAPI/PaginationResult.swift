//
//  PaginationResult.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
public struct PaginationResult<T> {
    public var items: [T]
    public var total: Int?

    
    public init(items: [T], total: Int?) {
        self.items = items
        self.total = total
    } 
}
 
