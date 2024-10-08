//
//  extension+Date.swift
 
 
import Foundation

/// Extension for `Date` providing a method to convert the date to a string with a specified time zone.
public extension Date {

    /// Converts the date to a string formatted with the specified time zone identifier.
    ///
    /// - Parameter timeZoneIdentifier: The identifier of the time zone to be used for formatting.
    /// - Returns: A string representing the date in the specified time zone format. Returns "Invalid time zone identifier" if the provided identifier is invalid.
    func toStringWithTimezone(timeZoneIdentifier: String? = nil) -> String {
        let pureDateFormatter = DateFormatter()
        pureDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        _ = pureDateFormatter.string(from: self)
        
        let currentTimeZonedateFormatter = DateFormatter()
        currentTimeZonedateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        currentTimeZonedateFormatter.timeZone = TimeZone.current
        // Format the date with the current time zone
        let currentTimeZoneDateString = currentTimeZonedateFormatter.string(from: self)
        
        // Get the time difference between GMT and the input time zone
        guard let inputTimeZone = TimeZone(identifier: timeZoneIdentifier ?? TimeZone.current.identifier) else {
            return "Invalid time zone identifier"
        }
        let gmtOffset = inputTimeZone.secondsFromGMT(for: self)
        let hours = gmtOffset / 3600
        let minutes = (abs(gmtOffset) / 60) % 60
        let timeDifferenceString = String(format: "%+.2d:%.2d", hours, minutes)
        
        // Construct the formatted string
        let formattedString = "\(currentTimeZoneDateString)\(timeDifferenceString)"
        
        return formattedString
    }
}



extension Date {
    /// Converts a `Date` to a string in the "dd MMM" format.
    ///
    /// - Returns: A string representing the date in the format "dd MMM", e.g., "17 Apr".
    func toDayMonthString(forTimeZone timeZone: TimeZone? = nil) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone ?? TimeZone.current
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }
}
