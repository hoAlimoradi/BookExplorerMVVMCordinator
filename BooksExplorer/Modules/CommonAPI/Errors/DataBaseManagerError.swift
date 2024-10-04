//
//  DataBaseManagerError.swift
 
import Foundation
/// An enumeration representing various errors that can occur in the database manager.
public enum DataBaseManagerError: Error, Equatable, CustomLocalizedError {
    case backgroundContextSaveError
    case mainContextSaveError
    case failedToOpen
    case notFoundInformation(String)
    case notImplemented(String) // New case for unimplemented features

    public var description: String {
        switch self {
        case .backgroundContextSaveError:
            return "Background context save error."
        case .mainContextSaveError:
            return "Main context save error."
        case .failedToOpen:
            return "Failed to open the database."
        case .notFoundInformation(let title):
            return "Information not found: \(title)."
        case .notImplemented(let feature):
            return "Not implemented: \(feature)." // Description for notImplemented
        }
    }

    public var customDescription: String {
        return description
    }
}
