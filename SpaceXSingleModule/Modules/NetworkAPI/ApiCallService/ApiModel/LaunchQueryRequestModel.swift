//
//  LaunchQueryRequestModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/10/1403 AP.
//
import Foundation

struct LaunchQueryRequestModel: Codable {
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
 
