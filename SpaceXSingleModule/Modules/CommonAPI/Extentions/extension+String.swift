//
//  extension+String.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation 

/// A public extension of `String` to provide date conversion capabilities with timezone support.
public extension String {
    /// Converts the string to a `Date` object using the specified timezone.
    ///
    /// The string is expected to be in the format "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ".
    /// If the provided timezone is `nil`, the current system timezone will be used.
    ///
    /// - Parameter timeZone: The timezone to use for date conversion. Pass `nil` to use the current system timezone.
    /// - Returns: A `Date` object representing the string, or the current date if the string could not be parsed.
    func convertToDateWithTimezone(forTimeZone timeZone: TimeZone? = nil) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        // Set the timezone, defaulting to the current system timezone if nil
        dateFormatter.timeZone = timeZone ?? .current
        
        return dateFormatter.date(from: self) ?? Date()
    }
}
