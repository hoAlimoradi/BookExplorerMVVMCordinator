//
//  CustomLocalizedError.swift
 
import Foundation

/// A protocol for defining errors with a custom description.
///
/// Types conforming to CustomLocalizedError must provide a customDescription property
/// to specify a custom description for the error.
public protocol CustomLocalizedError: Error {
    var customDescription: String { get }
} 
