//
//  URLSessionProviderProtocol.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation 

/// A protocol defining the interface for creating URL sessions.
///
/// This protocol provides a method to create URL sessions with optional SSL certificate pinning.
internal protocol URLSessionProviderProtocol {
    /// Creates a URL session for a given endpoint with an option to check SSL certificates.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint string for which the URL session is created.
    ///   - checkSSL: A boolean indicating whether SSL certificate pinning should be enabled.
    /// - Returns: An optional `URLSession` object configured based on the provided parameters.
    func getURLSession(from endpoint: String, checkSSL: Bool) -> URLSession?
}

