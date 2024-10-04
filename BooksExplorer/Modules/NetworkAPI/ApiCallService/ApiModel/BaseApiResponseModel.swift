//
//  BaseApiResponseModel.swift
 
import Foundation
/// Represents a generic API response model containing paginated data.
// MARK: - Generic API Response Model
struct BaseApiResponseModel<T: Codable>: Codable {
    let docs: [T]?
    let offset: Int?
    let start: Int
    let q: String
    let numFound, baseNumFound: Int
    let numFoundExact: Bool

    enum CodingKeys: String, CodingKey {
        case offset, start, docs, q, numFound
        case baseNumFound = "num_found"
        case numFoundExact
    }
}
 
