//
//  DataBaseAPIFactory.swift
 
import Foundation

/// A factory class to create the appropriate database API based on the selected database type.
public class DataBaseAPIFactory {
    
    /// Creates an instance of a database API based on the specified database type.
    /// - Parameter type: The type of database to use.
    /// - Returns: An instance of `DataBaseAPIProtocol` corresponding to the selected database type.
    public static func createDatabaseAPI(for type: DatabaseType) -> DataBaseAPIProtocol {
        switch type {
        case .realm:
            return RealmDataBaseAPI()
        case .coreData:
            return CoreDataBaseAPI()
        case .jsonFile:
            return JsonDataBaseAPI()
        }
    }
}
