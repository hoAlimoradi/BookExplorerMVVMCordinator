//
//  UserDefaultsProtocol.swift
 
import Foundation

/// Protocol to abstract `UserDefaults` functionality for storing and retrieving values.
public protocol UserDefaultsProtocol {

    /// Sets the value of the specified key in the user defaults.
    ///
    /// - Parameters:
    ///   - value: The value to store in the user defaults. This can be any type.
    ///   - forKey: The key with which to associate the value.
    func setValue(_ value: Any?, forKey: String)

    /// Returns the value associated with the specified key.
    ///
    /// - Parameter forKey: The key whose value you want to retrieve.
    /// - Returns: The value associated with the specified key, or `nil` if the key was not found.
    func value(forKey: String) -> Any?

    /// Removes the value of the specified key in the user defaults.
    ///
    /// - Parameter forKey: The key whose value you want to remove.
    func remove(forKey: String)
}

/// Extension to make `UserDefaults` conform to `UserDefaultsProtocol`.
extension UserDefaults: UserDefaultsProtocol {

    /// Removes the value of the specified key in the user defaults.
    ///
    /// - Parameter forKey: The key whose value you want to remove.
    public func remove(forKey key: String) {
        self.removeObject(forKey: key)
    }
}

