//
//  DataBaseAPI.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/10/1403 AP.
//
import CoreData
import Combine
import Foundation

/// A protocol defining the necessary methods and properties for interacting with a database of launch items.
public protocol DataBaseAPIProtocol {
    
    /// Retrieves all launch items from the database.
    /// - Returns: An array of `LaunchItemModel` objects.
    func getLaunchItems() async throws -> [LaunchItemModel]
    
    /// Saves a launch item to the database.
    /// - Parameter item: The `LaunchItemModel` to save.
    func saveLaunchItem(_ item: LaunchItemModel) async throws
    
    /// Checks if a launch item with the specified ID exists in the database.
    /// - Parameter id: The ID of the launch item to check.
    /// - Returns: A Boolean indicating whether the launch item exists.
    func isLaunchItemExist(with id: String) async throws -> Bool
    
    /// Deletes a launch item from the database by its ID.
    /// - Parameter id: The ID of the launch item to delete.
    func deleteLaunchItem(by id: String) async throws
    
    /// Retrieves the IDs of all launch items in the database.
    /// - Returns: An array of strings representing the IDs of the launch items.
    func getLaunchItemIDs() async throws -> [String]
    
    /// Updates an existing launch item in the database.
    /// - Parameter updatedItem: The `LaunchItemModel` containing the updated data.
    func updateLaunchItem(_ updatedItem: LaunchItemModel) async throws
    
    /// A publisher that notifies subscribers of changes to the database.
    var changePublisher: PassthroughSubject<Void, Never> { get }
}
/// A class that implements `DataBaseAPIProtocol` to manage launch items in a JSON-based database.
public final class DataBaseAPI: DataBaseAPIProtocol { 
    
    /// The publisher that notifies subscribers of changes to the database.
    private let changeSubject = PassthroughSubject<Void, Never>()
    
    public var changePublisher: PassthroughSubject<Void, Never> {
        return changeSubject
    }
    
    init() {
        copyJSONFileIfNeeded()
    }
    
    /// Copies the JSON file from the app bundle to the documents directory if it does not already exist.
    private func copyJSONFileIfNeeded() {
        let fileManager = FileManager.default
        let jsonFileURL = getJSONFileURL()
        
        guard !fileManager.fileExists(atPath: jsonFileURL.path) else {
            LoggingAPI.shared.log("LaunchItems.json already exists in the documents directory.", level: .info)
            return
        }
        
        if let bundleURL = Bundle.main.url(forResource: "LaunchItems", withExtension: "json") {
            do {
                try fileManager.copyItem(at: bundleURL, to: jsonFileURL)
                LoggingAPI.shared.log("Copied LaunchItems.json from bundle to documents directory.", level: .info)
            } catch {
                LoggingAPI.shared.log("Failed to copy LaunchItems.json from bundle to documents directory: \(error)", level: .error)
            }
        } else {
            do {
                let emptyArray: [LaunchDataBaseModel] = []
                let jsonData = try JSONEncoder().encode(emptyArray)
                try jsonData.write(to: jsonFileURL, options: .atomic)
                LoggingAPI.shared.log("Created empty LaunchItems.json in documents directory.", level: .info)
            } catch {
                LoggingAPI.shared.log("Failed to create empty LaunchItems.json: \(error)", level: .error)
            }
        }
    }
    
    /// Retrieves the URL of the JSON file in the documents directory.
    /// - Returns: The URL of the JSON file.
    private func getJSONFileURL() -> URL {
        LoggingAPI.shared.log("Getting JSON file URL", level: .info)
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFileURL = documentsURL.appendingPathComponent("LaunchItems.json")
        
        LoggingAPI.shared.log("JSON file URL is \(jsonFileURL.path)", level: .info)
        return jsonFileURL
    }
    
    /// Retrieves all launch items from the JSON file.
    /// - Returns: An array of `LaunchItemModel` objects.
    public func getLaunchItems() async throws -> [LaunchItemModel] {
        LoggingAPI.shared.log("Fetching launch items", level: .info)
        
        let fileURL = getJSONFileURL()
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            LoggingAPI.shared.log("LaunchItems.json not found at \(fileURL.path). Returning empty array.", level: .info)
            return []
        }
        
        do {
            LoggingAPI.shared.log("Reading data from \(fileURL.path)", level: .info)
            let data = try Data(contentsOf: fileURL)
            
            guard !data.isEmpty else {
                LoggingAPI.shared.log("LaunchItems.json is empty. Returning empty array.", level: .info)
                return []
            }
            
            LoggingAPI.shared.log("Data read successfully from \(fileURL.path)", level: .info)
            let databaseItems = try JSONDecoder().decode([LaunchDataBaseModel].self, from: data)
            LoggingAPI.shared.log("Decoded \(databaseItems.count) items from JSON data", level: .info)
            
            return databaseItems.map { $0.toLaunchItemModel() }
        } catch {
            LoggingAPI.shared.log("Failed to read or decode data from LaunchItems.json: \(error)", level: .error)
            throw error
        }
    }
    
    /// Saves a launch item to the JSON file.
    /// - Parameter item: The `LaunchItemModel` to save.
    public func saveLaunchItem(_ item: LaunchItemModel) async throws {
        LoggingAPI.shared.log("Saving launch item with id \(item.id)", level: .info)
        
        let fileURL = getJSONFileURL()
        var items: [LaunchItemModel]
        
        do {
            items = try await getLaunchItems()
        } catch {
            LoggingAPI.shared.log("Failed to fetch existing launch items. Initializing with an empty array.", level: .info)
            items = []
        }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            LoggingAPI.shared.log("Found existing item with id \(item.id). Updating item.", level: .info)
            items[index] = item
        } else {
            LoggingAPI.shared.log("No existing item found with id \(item.id). Adding new item.", level: .info)
            items.append(item)
        }
        
        let databaseItems = items.map { $0.toDataBaseModel() }
        let jsonData = try JSONEncoder().encode(databaseItems)
        LoggingAPI.shared.log("Encoded items to JSON data", level: .info)
        
        try jsonData.write(to: fileURL, options: .atomic)
        LoggingAPI.shared.log("Saved JSON data to \(fileURL.path)", level: .info)
        
        // Notify change
        changeSubject.send()
    }
    
    /// Checks if a launch item with the specified ID exists in the JSON file.
    /// - Parameter id: The ID of the launch item to check.
    /// - Returns: A Boolean indicating whether the launch item exists.
    public func isLaunchItemExist(with id: String) async throws -> Bool {
        LoggingAPI.shared.log("Checking if launch item exists with id \(id)", level: .info)
        
        let items = try await getLaunchItems()
        let exists = items.contains { $0.id == id }
        
        if (exists) {
            LoggingAPI.shared.log("Launch item with id \(id) exists", level: .info)
        } else {
            LoggingAPI.shared.log("No launch item found with id \(id)", level: .info)
        }
        
        return exists
    }
    
    /// Retrieves the IDs of all launch items from the JSON file.
    /// - Returns: An array of strings representing the IDs of the launch items.
    public func getLaunchItemIDs() async throws -> [String] {
        LoggingAPI.shared.log("Fetching launch item IDs", level: .info)
        
        let items = try await getLaunchItems()
        let ids = items.map { $0.id }
        
        LoggingAPI.shared.log("Fetched \(ids.count) launch item IDs", level: .info)
        
        return ids
    }
    
    /// Updates an existing launch item in the JSON file.
    /// - Parameter updatedItem: The `LaunchItemModel` containing the updated data.
    public func updateLaunchItem(_ updatedItem: LaunchItemModel) async throws {
        LoggingAPI.shared.log("Updating launch item with id \(updatedItem.id)", level: .info)
        
        let fileURL = getJSONFileURL()
        var items = try await getLaunchItems()
        
        guard let index = items.firstIndex(where: { $0.id == updatedItem.id }) else {
            LoggingAPI.shared.log("Item with id \(updatedItem.id) not found. Aborting update.", level: .info)
            throw NSError(domain: "LaunchItemNotFound", code: 404, userInfo: nil)
        }
        
        items[index] = updatedItem
        
        let databaseItems = items.map { $0.toDataBaseModel() }
        let jsonData = try JSONEncoder().encode(databaseItems)
        LoggingAPI.shared.log("Encoded updated items to JSON data", level: .info)
        
        try jsonData.write(to: fileURL, options: .atomic)
        LoggingAPI.shared.log("Saved updated JSON data to \(fileURL.path)", level: .info)
        
        // Notify change
        changeSubject.send()
    }
    
    /// Deletes a launch item from the JSON file by its ID.
    /// - Parameter id: The ID of the launch item to delete.
    public func deleteLaunchItem(by id: String) async throws {
        LoggingAPI.shared.log("Deleting launch item with id \(id)", level: .info)
        
        let fileURL = getJSONFileURL()
        var items = try await getLaunchItems()
        
        let initialCount = items.count
        items.removeAll(where: { $0.id == id })
        let finalCount = items.count
        
        LoggingAPI.shared.log("Removed \(initialCount - finalCount) item(s) with id \(id)", level: .info)
        
        let databaseItems = items.map { $0.toDataBaseModel() }
        let jsonData = try JSONEncoder().encode(databaseItems)
        
        try jsonData.write(to: fileURL, options: .atomic)
        LoggingAPI.shared.log("Saved updated JSON data to \(fileURL.path)", level: .info)
        
        // Notify change
        changeSubject.send()
    }
}

 
