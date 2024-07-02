//
//  BaseApiResponseModel.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
/// Represents a generic API response model containing paginated data.
struct BaseApiResponseModel<T: Codable>: Codable {
    /// The next page number if available.
    let nextPage: Int?
    
    /// The documents or items of type `T` returned in the response.
    let docs: T?
    
    /// Total number of pages available.
    let totalPages: Int
    
    /// Date information associated with the response.
    let date: String?
    
    /// The limit of items per page.
    let limit: Int?
    
    /// Total number of documents or items in the entire dataset.
    let totalDocs: Int
    
    /// Counter for paging.
    let pagingCounter: Int
    
    /// Indicates if there is a previous page available.
    let hasPrevPage: Bool
    
    /// Current page number.
    let page: Int
    
    /// Indicates if there is a next page available.
    let hasNextPage: Bool
    
    /// The previous page number if available.
    let prevPage: Int?

    /// Coding keys to map JSON keys to Swift properties.
    enum CodingKeys: String, CodingKey {
        case nextPage
        case docs
        case totalPages
        case date
        case limit
        case totalDocs
        case pagingCounter
        case hasPrevPage
        case page
        case hasNextPage
        case prevPage
    }
}

