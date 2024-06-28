//
//  HttpClientManagerAPIError.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation

//MARK: -- HttpClientManager Error Enum
/// Error Type indicating why an operation has failed
/// To print out the error just call its ``description`` property.
public enum HttpClientManagerAPIError: Error, Equatable, CustomLocalizedError {
    
    /// A string describing the error.
    public typealias ErrorDescription = String

    case invalidURLComponents
    case networkNotReachable
    case unableToProvideURLSession
   
    case unauthorized
    
    /// An error indicating  usser banned.
    case notAcceptable
    
    /// An error indicating  server message was returned.
    case metaClientMessageError(String)
    
    /// An error indicating that no content   was returned.
    case noContent
    
    /// A generic error with a description.
    case generic(ErrorDescription)

    /// An error indicating a bad URL request. Passes a description of the url.
    case badURL(ErrorDescription)

    
    /// Parse Error from Converting Json String to Struct
    case deserialize(ErrorDescription)
    
    public var description: String {
            switch self {
            case .invalidURLComponents:
                return "The provided URL is not valid."
            case .networkNotReachable:
                return "Oops, connection issue! Check your internet and try again. If it persists, our servers might be taking a quick timeout. We're strategizing for a comeback!"
            case .unableToProvideURLSession:
                return "There was a problem establishing a connection."
            case .unauthorized:
                return "Connection error. Please try again." //"You are not authorized to perform this action."
            case .generic(let description):
                return description
            case .metaClientMessageError(let errorDescription):
                return " \(errorDescription)"
            case .noContent:
                return "No data was found for your request."
            case .badURL(let description):
                return "The URL provided is not valid: \(description)"
            case .notAcceptable:
                return "Access denied. Your user account has been banned."
            case .deserialize(let description):
                return "\(description)"
            }
        }
    // Override the localizedDescription property from the Error protocol to return the description value.
    public var customDescription: String {
        return description
    }
}
