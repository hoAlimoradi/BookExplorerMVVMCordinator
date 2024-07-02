//
//  LauncheAPI.swift
//  LauncheAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
import Combine
import UIKit

/// A protocol defining methods and properties for interacting with launch items.
public protocol LaunchAPIProtocol {
    
    /// Retrieves paginated launch items based on the provided pagination model.
    /// - Parameter paginationModel: The `PaginationModel` specifying pagination parameters.
    /// - Returns: A `PaginationResult` containing an array of `LaunchItemModel` objects.
    func getLaunchItems(by paginationModel: PaginationModel) async throws -> PaginationResult<LaunchItemModel>
    
    /// Retrieves all favorite launch items.
    /// - Returns: An array of `LaunchItemModel` objects representing favorite launches.
    func getFavoriteLaunchItems() async throws -> [LaunchItemModel]
    
    /// Saves a launch item as a favorite.
    /// - Parameter item: The `LaunchItemModel` to save as a favorite.
    func saveFavoriteLaunchItem(_ item: LaunchItemModel) async throws
    
    /// Checks if a launch item with the specified ID exists in favorites.
    /// - Parameter id: The ID of the launch item to check.
    /// - Returns: A Boolean indicating whether the launch item exists in favorites.
    func isLaunchItemExist(with id: String) async throws -> Bool
    
    /// Deletes a launch item from favorites by its ID.
    /// - Parameter id: The ID of the launch item to delete from favorites.
    func deleteFavoriteLaunchItem(by id: String) async throws
    
    /// Retrieves the IDs of all launch items in favorites.
    /// - Returns: An array of strings representing the IDs of the launch items in favorites.
    func getLaunchItemIDs() async throws -> [String]
    
    /// Updates an existing launch item.
    /// - Parameter updatedItem: The `LaunchItemModel` containing the updated data.
    func updateLaunchItem(_ updatedItem: LaunchItemModel) async throws
    
    /// Updates multiple launch items.
    /// - Parameter updatedItems: An array of `LaunchItemModel` objects containing the updated data.
    func updateLaunchItems(_ updatedItems: [LaunchItemModel]) async throws
    
    /// A publisher that notifies subscribers when favorite launch items should be refreshed.
    var shouldRefreshreshFavoriteePublisher: PassthroughSubject<Void, Never> { get }
}

/// A concrete implementation of `LaunchAPIProtocol` that manages operations related to launch items.
final public class LaunchAPI: LaunchAPIProtocol {
    
    /// Constants used within the `LaunchAPI` class.
    private enum Constants {
    }
    
    /// Set to hold cancellables for managing subscriptions.
    private var cancelables = Set<AnyCancellable>()
    
    /// The network API instance used for fetching launch items.
    private let networkAPI: NetworkAPIProtocol
    
    /// The database API instance used for storing and managing launch items.
    private let dataBaseAPI: DataBaseAPIProtocol
    
    /// Initializes an instance of `LaunchAPI` with optional dependencies.
    /// - Parameters:
    ///   - dataBaseAPI: The database API instance to use. Defaults to `DataBaseAPI.shared`.
    ///   - networkAPI: The network API instance to use. Defaults to `NetworkAPI.shared`.
    public init(dataBaseAPI: DataBaseAPIProtocol = DataBaseAPI.shared,
                networkAPI: NetworkAPIProtocol = NetworkAPI.shared) {
        self.dataBaseAPI = dataBaseAPI
        self.networkAPI = networkAPI
        observeDataBasePublisher()
    }
    
    /// Deinitializes the `LaunchAPI` instance and cancels all subscriptions.
    deinit {
        cancelables.forEach { $0.cancel() }
    }
    
    /// Observes changes in the database and triggers a refresh of favorite launch items.
    private func observeDataBasePublisher() {
        dataBaseAPI.changePublisher.sink { [weak self] _ in
            guard let self = self else { return }
            LoggingAPI.shared.log("Database change detected.", level: .info)
            self.shouldRefreshreshFavoriteePublisher.send()
        }.store(in: &cancelables)
    }
    
    /// Subject for triggering a refresh of favorite launch items.
    private let shouldRefreshreshFavoriteeSubject = PassthroughSubject<Void, Never>()
    
    /// Publisher for notifying subscribers when favorite launch items should be refreshed.
    public var shouldRefreshreshFavoriteePublisher: PassthroughSubject<Void, Never> {
        return shouldRefreshreshFavoriteeSubject
    }
    
    /// Retrieves paginated launch items from the network API.
    /// - Parameter paginationModel: The `PaginationModel` specifying pagination parameters.
    /// - Returns: A `PaginationResult` containing an array of `LaunchItemModel` objects.
    public func getLaunchItems(by paginationModel: PaginationModel) async throws -> PaginationResult<LaunchItemModel> {
        return try await networkAPI.getLaunchItems(by: paginationModel)
    }
    
    /// Retrieves all favorite launch items from the database.
    /// - Returns: An array of `LaunchItemModel` objects representing favorite launches.
    public func getFavoriteLaunchItems() async throws -> [LaunchItemModel] {
        return try await dataBaseAPI.getLaunchItems()
    }
    
    /// Saves a launch item as a favorite in the database.
    /// - Parameter item: The `LaunchItemModel` to save as a favorite.
    public func saveFavoriteLaunchItem(_ item: LaunchItemModel) async throws {
        return try await dataBaseAPI.saveLaunchItem(item)
    }
    
    /// Checks if a launch item with the specified ID exists in favorites.
    /// - Parameter id: The ID of the launch item to check.
    /// - Returns: A Boolean indicating whether the launch item exists in favorites.
    public func isLaunchItemExist(with id: String) async throws -> Bool {
        return try await dataBaseAPI.isLaunchItemExist(with: id)
    }
    
    /// Deletes a launch item from favorites by its ID.
    /// - Parameter id: The ID of the launch item to delete from favorites.
    public func deleteFavoriteLaunchItem(by id: String) async throws {
        return try await dataBaseAPI.deleteLaunchItem(by: id)
    }
    
    /// Retrieves the IDs of all launch items in favorites.
    /// - Returns: An array of strings representing the IDs of the launch items in favorites.
    public func getLaunchItemIDs() async throws -> [String] {
        return try await dataBaseAPI.getLaunchItemIDs()
    }
    
    /// Updates multiple launch items in the database.
    /// - Parameter updatedItems: An array of `LaunchItemModel` objects containing the updated data.
    public func updateLaunchItems(_ updatedItems: [LaunchItemModel]) async throws {
        for updatedItem in updatedItems {
            try await dataBaseAPI.updateLaunchItem(updatedItem)
        }
    }
    
    /// Updates a single launch item in the database.
    /// - Parameter updatedItem: The `LaunchItemModel` containing the updated data.
    public func updateLaunchItem(_ updatedItem: LaunchItemModel) async throws {
        try await dataBaseAPI.updateLaunchItem(updatedItem)
    }
}

