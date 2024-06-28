//
//  NetworkAPIError.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//
 
import Foundation 
//MARK: -- NetworkAPI Error Enum
/// Error Type indicating why an operation has failed
/// To print out the error just call its ``description`` property.

public enum NetworkAPIError: Error, Equatable, CustomLocalizedError {
    /// An error indicating  server message was returned.
    case metaClientMessageError(String?)
    
    /// An error indicating that no content   was returned.
    case noContent

    case emptyList
    
    public var description: String {
        switch self {
        case .metaClientMessageError(let errorDescription):
            return errorDescription ?? "No content was found"
        case .noContent:
            return "No content was found"
        case .emptyList:
            return "List is empty"
        }
    }
    // Override the localizedDescription property from the Error protocol to return the description value.
    public var customDescription: String {
        return description
    }
}
