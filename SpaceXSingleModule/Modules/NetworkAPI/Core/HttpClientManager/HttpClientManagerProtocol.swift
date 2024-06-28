//
//  HttpClientManagerProtocol.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation
import Combine
import UIKit

/// A protocol defining the interface for an HTTP client manager.
///
/// This protocol provides methods to perform HTTP GET requests asynchronously,
/// handling Codable responses and optionally checking HTTP status codes.
internal protocol HttpClientManagerProtocol {
    
    /// Performs an asynchronous HTTP GET request.
    ///
    /// - Parameters:
    ///   - headerFields: Optional header fields to be included in the request.
    ///   - endpoint: The endpoint or URL path for the GET request.
    ///   - queryItemsParameters: Optional query parameters for the GET request.
    ///   - authenticationIsRequired: Indicates whether authentication is required for the request.
    ///   - checkHTTPStatusCode: Indicates whether to check HTTP status codes for success.
    /// - Returns: A generic object of type `T`, decoded from the response data.
    /// - Throws: An error of type `Error`, including networking errors and decoding errors.
    func get<T: Codable>(headerFields: [HeaderFieldModel]?,
                         endpoint: String,
                         queryItemsParameters: [String: Any]?,
                         authenticationIsRequired: Bool,
                         checkHTTPStatusCode: Bool) async throws -> T
}

