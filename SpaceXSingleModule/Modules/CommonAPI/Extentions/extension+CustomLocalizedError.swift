//
//  extension+CustomLocalizedError.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation

/// An extension on CustomLocalizedError protocol providing a default implementation for localizedDescription.
///
/// This extension ensures that types conforming to CustomLocalizedError automatically
/// use their customDescription property as their localized description.
public extension CustomLocalizedError {
    var localizedDescription: String {
        return customDescription
    }
}
