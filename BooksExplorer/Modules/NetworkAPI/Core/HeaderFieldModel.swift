//
//  HeaderFieldModel.swift
 
import Foundation
/// A model representing an HTTP header field.
///
/// `HeaderFieldModel` encapsulates a key-value pair representing an HTTP header field,
/// where `key` is the name of the header and `value` is the corresponding value.
///
/// Usage Example:
/// ```
/// let headerField = HeaderFieldModel(key: "Content-Type", value: "application/json")
/// ```
///
/// - Parameters:
///   - key: The name of the header field.
///   - value: The value of the header field.
internal struct HeaderFieldModel {
    var key: String
    var value: String
}
