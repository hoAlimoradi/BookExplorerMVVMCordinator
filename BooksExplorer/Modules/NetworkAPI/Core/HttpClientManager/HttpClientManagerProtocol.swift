//
//  HttpClientManagerProtocol.swift
 
import Foundation
import Combine
import UIKit

/// A protocol defining the interface for an HTTP client manager.
///
/// This protocol provides methods to perform HTTP GET/POST  requests asynchronously,
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
    
    /// Performs an HTTP POST request with customizable parameters.
    ///
    /// - Parameters:
    ///   - headerFields: Optional array of header fields for the request.
    ///   - requestBody: Optional data representing the body of the request.
    ///   - queryItemsParameters: Optional dictionary of query items parameters.
    ///   - endpoint: The endpoint or path for the API request.
    ///   - authenticationIsRequired: Boolean flag indicating if authentication is required for the request.
    ///   - checkHTTPStatusCode: Boolean flag indicating if HTTP status code needs to be checked.
    /// - Returns: A decoded instance of type `T` representing the response data.
    /// - Throws: An error if the request fails or if decoding the response data fails.
    func post<T: Codable>(headerFields: [HeaderFieldModel]?,
                          requstBody: Data?,
                          queryItemsParameters: [String: Any]?,
                          endpoint: String,
                          authenticationIsRequired: Bool,
                          checkHTTPStatusCode: Bool) async throws -> T
}

