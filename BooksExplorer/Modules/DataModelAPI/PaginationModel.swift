//
//  PaginationModel.swift
//  
 
import Foundation
/// Represents a pagination configuration used for fetching items from a paginated data source.
public struct PaginationModel {
    /// The default page size for pagination.
    public static let defaultPageSize = 2
    
    /// The current page number.
    public var page: Int {
        didSet {
            offset = page * size
        }
    }
    
    /// The size of items per page.
    public var size: Int {
        didSet {
            offset = page * size
        }
    }
    
    /// The calculated offset based on the current page and size.
    public private(set) var offset: Int

    /// Initializes a new instance of `PaginationModel`.
    ///
    /// - Parameters:
    ///   - page: The current page number.
    ///   - size: The size of items per page. Defaults to `PaginationModel.defaultPageSize`.
    public init(page: Int, size: Int = PaginationModel.defaultPageSize) {
        self.page = page
        self.size = size
        self.offset = page * size
    }
}

 
