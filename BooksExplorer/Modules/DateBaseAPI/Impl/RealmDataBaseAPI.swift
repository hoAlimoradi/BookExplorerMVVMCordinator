//
//  RealmDataBaseAPI.swift
 
import Combine

/// A class that implements `DataBaseAPIProtocol` to manage Book items in a Realm-based database.
public final class RealmDataBaseAPI: DataBaseAPIProtocol {
    public var changePublisher = PassthroughSubject<Void, Never>()
    
    public func getBookItems() async throws -> [BookItemModel] {
        throw DataBaseManagerError.notImplemented("Fetching book items from Realm is not implemented yet.")
    }
    
    public func saveBookItem(_ item: BookItemModel) async throws {
        throw DataBaseManagerError.notImplemented("Saving book items to Realm is not implemented yet.")
    }
    
    public func isBookItemExist(with id: String) async throws -> Bool {
        throw DataBaseManagerError.notImplemented("Checking if a book item exists in Realm is not implemented yet.")
    }
    
    public func deleteBookItem(by id: String) async throws {
        throw DataBaseManagerError.notImplemented("Deleting book items from Realm is not implemented yet.")
    }
    
    public func getBookItemIDs() async throws -> [String] {
        throw DataBaseManagerError.notImplemented("Fetching book item IDs from Realm is not implemented yet.")
    }
    
    public func updateBookItem(_ updatedItem: BookItemModel) async throws {
        throw DataBaseManagerError.notImplemented("Updating book items in Realm is not implemented yet.")
    } 
}
