//
//  DataBaseAPIProtocol.swift
//  
 
 
import CoreData
import Combine
import Foundation

/// A protocol that defines the necessary methods for a database strategy.
public protocol DataBaseAPIProtocol {
    
    /// Retrieves all Book items from the database.
    /// - Returns: An array of `BookItemModel` objects.
    func getBookItems() async throws -> [BookItemModel]
    
    /// Saves a Book item to the database.
    /// - Parameter item: The `BookItemModel` to save.
    func saveBookItem(_ item: BookItemModel) async throws
    
    /// Checks if a Book item with the specified ID exists in the database.
    /// - Parameter id: The ID of the Book item to check.
    /// - Returns: A Boolean indicating whether the Book item exists.
    func isBookItemExist(with id: String) async throws -> Bool
    
    /// Deletes a Book item from the database by its ID.
    /// - Parameter id: The ID of the Book item to delete.
    func deleteBookItem(by id: String) async throws
    
    /// Retrieves the IDs of all Book items in the database.
    /// - Returns: An array of strings representing the IDs of the Book items.
    func getBookItemIDs() async throws -> [String]
    
    /// Updates an existing Book item in the database.
    /// - Parameter updatedItem: The `BookItemModel` containing the updated data.
    func updateBookItem(_ updatedItem: BookItemModel) async throws
    
    /// A publisher that notifies subscribers of changes to the database.
    var changePublisher: PassthroughSubject<Void, Never> { get }
}
