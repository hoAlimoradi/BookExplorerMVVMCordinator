//
//  extension+Error.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
/// An extension on the Error protocol providing a computed property for custom localized description.
///
/// This extension allows errors conforming to CustomLocalizedError to provide a custom localized description
/// using the customDescription property. If the error does not conform to CustomLocalizedError,
/// it falls back to using the standard localizedDescription of the Error protocol.
public extension Error {
    var customLocalizedDescription: String {
        return (self as? CustomLocalizedError)?.localizedDescription ?? self.localizedDescription
    }
}
