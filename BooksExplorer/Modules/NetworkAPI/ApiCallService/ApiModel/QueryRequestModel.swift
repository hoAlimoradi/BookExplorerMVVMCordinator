//
//  LaunchQueryRequestModel.swift
 
import Foundation

struct QueryRequestModel: Codable {
    let query: Query
    let options: Options
    
    struct Query: Codable {
        // Define the properties for the query part if needed
    }
    
    struct Options: Codable {
        let limit: Int
        let page: Int
    }
}
 
