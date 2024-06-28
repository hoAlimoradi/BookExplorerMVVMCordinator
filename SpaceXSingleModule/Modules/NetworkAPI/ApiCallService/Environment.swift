//
//  Environment.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
 
import Foundation

enum Environment {
    
    case development

    var apiBaseUrl: String {
        return fetchInfoPlistValue(for: "ApiBaseUrl")
    }

    private func fetchInfoPlistValue(for key: String) -> String {
        let frameworkBundle = Bundle(for: URLSessionProvider.self)
        if let value = frameworkBundle.infoDictionary?[key] as? String {
            return value
        } else {
            fatalError("\(key) not set in plist for this environment")
        }
    }

    static var current: Environment {
        // Logic to determine the current environment
        // For simplicity, returning .development
        // Expand this as needed
        return .development
    }
}
