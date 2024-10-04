//
//  BookeAPI.swift
 
import Foundation
import Combine
import UIKit

/// A protocol defining methods and properties for interacting with Book items.
public protocol SearchBookAPIProtocol {
    
    /// Retrieves paginated Book items based on the provided pagination model.
    /// - Parameter paginationModel: The `PaginationModel` specifying pagination parameters.
    /// - Returns: A `PaginationResult` containing an array of `BookItemModel` objects.
    func searchBooks(by query: String?, pagination: PaginationModel) async throws -> PaginationResult<BookItemModel>
    func getBooks(by pagination: PaginationModel) async throws -> PaginationResult<BookItemModel>
    /// Retrieves all favorite Book items.
    /// - Returns: An array of `BookItemModel` objects representing favorite Bookes.
    func getFavoriteBookItems() async throws -> [BookItemModel]
    
    /// Saves a Book item as a favorite.
    /// - Parameter item: The `BookItemModel` to save as a favorite.
    func saveFavoriteBookItem(_ item: BookItemModel) async throws
    
    /// Checks if a Book item with the specified ID exists in favorites.
    /// - Parameter id: The ID of the Book item to check.
    /// - Returns: A Boolean indicating whether the Book item exists in favorites.
    func isBookItemExist(with id: String) async throws -> Bool
    
    /// Deletes a Book item from favorites by its ID.
    /// - Parameter id: The ID of the Book item to delete from favorites.
    func deleteFavoriteBookItem(by id: String) async throws
    
    /// Retrieves the IDs of all Book items in favorites.
    /// - Returns: An array of strings representing the IDs of the Book items in favorites.
    func getBookItemIDs() async throws -> [String]
    
    /// Updates an existing Book item.
    /// - Parameter updatedItem: The `BookItemModel` containing the updated data.
    func updateBookItem(_ updatedItem: BookItemModel) async throws
    
    /// Updates multiple Book items.
    /// - Parameter updatedItems: An array of `BookItemModel` objects containing the updated data.
    func updateBookItems(_ updatedItems: [BookItemModel]) async throws
    
    /// A publisher that notifies subscribers when favorite Book items should be refreshed.
    var shouldRefreshreshFavoriteePublisher: PassthroughSubject<Void, Never> { get }
}

/// A concrete implementation of `SearchBookAPIProtocol` that manages operations related to Book items.
final public class SearchBookAPI: SearchBookAPIProtocol {
     
    /// Constants used within the `BookAPI` class.
    private enum Constants {
    }
    
    /// Set to hold cancellables for managing subscriptions.
    private var cancelables = Set<AnyCancellable>()
    
    /// The network API instance used for fetching Book items.
    private let networkAPI: NetworkAPIProtocol
    
    /// The database API instance used for storing and managing Book items.
    private let dataBaseAPI: DataBaseAPIProtocol
    
    /// Initializes an instance of `BookAPI` with optional dependencies.
    /// - Parameters:
    ///   - dataBaseAPI: The database API instance to use
    ///   - networkAPI: The network API instance to use.
    public init(dataBaseAPI: DataBaseAPIProtocol ,
                networkAPI: NetworkAPIProtocol) {
        self.dataBaseAPI = dataBaseAPI
        self.networkAPI = networkAPI
        observeDataBasePublisher()
    }
    
    /// Deinitializes the `BookAPI` instance and cancels all subscriptions.
    deinit {
        cancelables.forEach { $0.cancel() }
    }
    
    /// Observes changes in the database and triggers a refresh of favorite Book items.
    private func observeDataBasePublisher() {
        dataBaseAPI.changePublisher.sink { [weak self] _ in
            guard let self = self else { return }
            LoggingAPI.shared.log("Database change detected.", level: .info)
            self.shouldRefreshreshFavoriteePublisher.send()
        }.store(in: &cancelables)
    }
    
    /// Subject for triggering a refresh of favorite Book items.
    private let shouldRefreshreshFavoriteeSubject = PassthroughSubject<Void, Never>()
    
    /// Publisher for notifying subscribers when favorite Book items should be refreshed.
    public var shouldRefreshreshFavoriteePublisher: PassthroughSubject<Void, Never> {
        return shouldRefreshreshFavoriteeSubject
    }
    
    /// Retrieves paginated Book items from the network API.
    /// - Parameter paginationModel: The `PaginationModel` specifying pagination parameters.
    /// - Returns: A `PaginationResult` containing an array of `BookItemModel` objects. 
    public func searchBooks(by query: String?, pagination: PaginationModel) async throws -> PaginationResult<BookItemModel> {
        return try await networkAPI.searchBooks(by: query, pagination: pagination)
    }
    
    public func getBooks(by pagination: PaginationModel) async throws -> PaginationResult<BookItemModel> {
        return try await networkAPI.searchBooks(by: nil, pagination: pagination)
    }
    
    /// Retrieves all favorite Book items from the database.
    /// - Returns: An array of `BookItemModel` objects representing favorite Bookes.
    public func getFavoriteBookItems() async throws -> [BookItemModel] {
        return try await dataBaseAPI.getBookItems()
    }
    
    /// Saves a Book item as a favorite in the database.
    /// - Parameter item: The `BookItemModel` to save as a favorite.
    public func saveFavoriteBookItem(_ item: BookItemModel) async throws {
        return try await dataBaseAPI.saveBookItem(item)
    }
    
    /// Checks if a Book item with the specified ID exists in favorites.
    /// - Parameter id: The ID of the Book item to check.
    /// - Returns: A Boolean indicating whether the Book item exists in favorites.
    public func isBookItemExist(with id: String) async throws -> Bool {
        return try await dataBaseAPI.isBookItemExist(with: id)
    }
    
    /// Deletes a Book item from favorites by its ID.
    /// - Parameter id: The ID of the Book item to delete from favorites.
    public func deleteFavoriteBookItem(by id: String) async throws {
        return try await dataBaseAPI.deleteBookItem(by: id)
    }
    
    /// Retrieves the IDs of all Book items in favorites.
    /// - Returns: An array of strings representing the IDs of the Book items in favorites.
    public func getBookItemIDs() async throws -> [String] {
        return try await dataBaseAPI.getBookItemIDs()
    }
    
    /// Updates multiple Book items in the database.
    /// - Parameter updatedItems: An array of `BookItemModel` objects containing the updated data.
    public func updateBookItems(_ updatedItems: [BookItemModel]) async throws {
        for updatedItem in updatedItems {
            try await dataBaseAPI.updateBookItem(updatedItem)
        }
    }
    
    /// Updates a single Book item in the database.
    /// - Parameter updatedItem: The `BookItemModel` containing the updated data.
    public func updateBookItem(_ updatedItem: BookItemModel) async throws {
        try await dataBaseAPI.updateBookItem(updatedItem)
    }
}

