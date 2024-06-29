//
//  PaginationModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
public let PaginationModelPageSize = 30
public struct PaginationModel1 {
    public var page: Int
    public var size: Int

    public init(page: Int, size: Int = PaginationModelPageSize) {
        self.page = page
        self.size = size
    }
}
public struct PaginationModel {
    public var page: Int {
        didSet {
            offset = page * size
        }
    }
    public var size: Int {
        didSet {
            offset = page * size
        }
    }
    
    /// The calculated offset based on page and size.
    public private(set) var offset: Int

    /// Initializes a new instance of `PaginationModel`.
    ///
    /// - Parameters:
    ///   - page: The current page number.
    ///   - size: The size of items per page.
    public init(page: Int, size: Int = PaginationModelPageSize) {
        self.page = page
        self.size = size
        self.offset = page * size
    }
}
 
