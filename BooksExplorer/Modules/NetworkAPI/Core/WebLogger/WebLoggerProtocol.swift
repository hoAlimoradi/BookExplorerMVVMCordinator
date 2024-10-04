//
//  WebLoggerProtocol.swift
 

import Foundation

/// Protocol for web logging functionality.
internal protocol WebLoggerProtocol {
    /// Sends an error log with the specified file path, line number, and function name.
    ///
    /// - Parameters:
    ///   - filePath: The file path where the error occurred.
    ///   - line: The line number where the error occurred.
    ///   - funcName: The name of the function where the error occurred.
    func sendError(filePath: String, line: Int?, funcName: String?)
    
    /// Sends error information to Sentry with detailed request parameters.
    ///
    /// - Parameters:
    ///   - httpMethodType: The HTTP method type of the request.
    ///   - endpoint: The endpoint URL of the request.
    ///   - queryItemsParameters: The query parameters of the request.
    ///   - authenticationIsRequired: A flag indicating if authentication is required.
    ///   - tagKey: The key for the tag.
    ///   - tagValue: The value for the tag.
    ///   - error: The error that occurred.
    ///   - message: The error message.
    func sendErrorToSentry(httpMethodType: String,
                           endpoint: String,
                           queryItemsParameters: [String: Any]?,
                           authenticationIsRequired: Bool,
                           tagKey: String,
                           tagValue: String,
                           error: Error,
                           message: String)
    
    /// Sends request information to Sentry.
    ///
    /// - Parameter urlRequest: The URL request to log.
    func sendRequestInfoToSentry(with urlRequest: URLRequest)
    
    /// Sends response information to Sentry.
    ///
    /// - Parameter response: The HTTP response to log.
    func sendResponseInfoToSentry(with response: HTTPURLResponse) 
}
