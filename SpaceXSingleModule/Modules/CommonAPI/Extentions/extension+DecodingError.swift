//
//  extension+DecodingError.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation

/// Extension to provide a detailed description for `DecodingError`.
public extension DecodingError {
    /// A detailed description of the decoding error.
    ///
    /// This computed property returns a more informative description of the decoding error,
    /// including the type expected, the actual value found, and the key path where the error occurred.
    /// - Returns: A string containing the detailed description of the decoding error.
    var detailedDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            return "Type mismatch: Expected \(type), but found \(context.debugDescription) at key path: \(codingPath)"
        default:
            return localizedDescription
        }
    }
}
