//
//  extension+Data.swift
//  CommonAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation

/// Extension to provide a method for pretty-printing JSON data.
public extension Data {
    /// Returns a pretty-printed JSON string if the data represents valid JSON.
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else { return nil }
        return prettyPrintedString
    }
}
