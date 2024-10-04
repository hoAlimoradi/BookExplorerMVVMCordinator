//
//  DataBaseAPIBuilder.swift
//  
 

import Foundation
/// A builder class to create an instance of `DataBaseAPIProtocol` based on the selected database type.
public class DataBaseAPIBuilder {
    private var databaseType: DatabaseType?
    
    /// Sets the database type for the builder.
    /// - Parameter type: The type of database to use.
    /// - Returns: The current instance of `DataBaseAPIBuilder`.
    @discardableResult
    public func withDatabaseType(_ type: DatabaseType) -> DataBaseAPIBuilder {
        self.databaseType = type
        return self
    }
    
    /// Builds an instance of the appropriate `DataBaseAPIProtocol` based on the selected database type.
    /// - Throws: An error if the database type is not set.
    /// - Returns: An instance of `DataBaseAPIProtocol`.
    public func build() throws -> DataBaseAPIProtocol {
        guard let type = databaseType else {
            throw DataBaseManagerError.notImplemented("Database type not set.")
        }
        return DataBaseAPIFactory.createDatabaseAPI(for: type)
    }
}
