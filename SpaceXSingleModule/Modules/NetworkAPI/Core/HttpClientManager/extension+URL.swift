//
//  extension+URL.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation

/// Internal extension to provide debugging capabilities to URLRequest.
internal extension URLRequest {
    
    /// Logs the details of the URLRequest, including HTTP method, URL, headers, and body.
    ///
    /// This method logs the HTTP method, URL, headers, and body of the request using the `LoggingAPI`.
    /// It is useful for debugging purposes to see the full details of a URLRequest.
    func debug() {
        LoggingAPI.shared.log(" \n URLRequest \n  \(self.httpMethod!) \(self.url!) \n  Headers: \(self.allHTTPHeaderFields!)  \n  Body: \(String(describing: String(data: self.httpBody ?? Data(), encoding: .utf8)!))", level: .info)
    }
}

/// Internal extension to convert a dictionary to an array of URLQueryItem.
internal extension Dictionary where Key == String, Value == Any {
    
    /// Converts the dictionary to an array of URLQueryItem.
    ///
    /// This property iterates over the dictionary and converts each key-value pair
    /// to a URLQueryItem, provided the value can be cast to a string.
    /// - Returns: An array of URLQueryItem representing the dictionary.
    var asURLQueryItems: [URLQueryItem] {
        return self.compactMap { (key, value) -> URLQueryItem? in
            guard let stringValue = value as? String else { return nil }
            return URLQueryItem(name: key, value: stringValue)
        }
    }
}

/// Internal extension to append query items to a URL.
internal extension URL {
    
    /// Appends query items from a dictionary to the URL.
    ///
    /// This method takes a dictionary of parameters and appends each key-value pair
    /// as a query item to the URL. It updates the URL with the new query items.
    /// - Parameter parameters: A dictionary of query parameters to append to the URL.
    mutating func appendQueryItems(parameters: [String: Any]) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        // Append each item from the dictionary to the query items array
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        
        // Assign the updated query items to the URL components
        urlComponents.queryItems = queryItems
        
        // Update the URL with the new components
        self = urlComponents.url!
    }
}
