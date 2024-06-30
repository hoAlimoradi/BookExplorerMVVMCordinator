//
//  BaseApiResponseModel.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
struct BaseApiResponseModel<T: Codable>: Codable {
    let nextPage: Int?
    let docs: T?
    let totalPages: Int
    let date: String?
    let limit: Int?
    let totalDocs: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let page: Int
    let hasNextPage: Bool
    let prevPage: Int?

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
