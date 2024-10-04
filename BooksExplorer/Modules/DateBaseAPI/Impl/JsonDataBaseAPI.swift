//
//  DataBaseAPI.swift
//  
 
import Combine
import Foundation
  
/// A class that implements `DataBaseAPIProtocol` to manage Book items in a JSON-based database.
public final class JsonDataBaseAPI: DataBaseAPIProtocol { 
    
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
            LoggingAPI.shared.log("BookItems.json already exists in the documents directory.", level: .info)
            return
        }
        
        if let bundleURL = Bundle.main.url(forResource: "BookItems", withExtension: "json") {
            do {
                try fileManager.copyItem(at: bundleURL, to: jsonFileURL)
                LoggingAPI.shared.log("Copied BookItems.json from bundle to documents directory.", level: .info)
            } catch {
                LoggingAPI.shared.log("Failed to copy BookItems.json from bundle to documents directory: \(error)", level: .error)
            }
        } else {
            do {
                let emptyArray: [BookDataBaseModel] = []
                let jsonData = try JSONEncoder().encode(emptyArray)
                try jsonData.write(to: jsonFileURL, options: .atomic)
                LoggingAPI.shared.log("Created empty BookItems.json in documents directory.", level: .info)
            } catch {
                LoggingAPI.shared.log("Failed to create empty BookItems.json: \(error)", level: .error)
            }
        }
    }
    
    /// Retrieves the URL of the JSON file in the documents directory.
    /// - Returns: The URL of the JSON file.
    private func getJSONFileURL() -> URL {
        LoggingAPI.shared.log("Getting JSON file URL", level: .info)
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFileURL = documentsURL.appendingPathComponent("BookItems.json")
        
        LoggingAPI.shared.log("JSON file URL is \(jsonFileURL.path)", level: .info)
        return jsonFileURL
    }
    
    /// Retrieves all Book items from the JSON file.
    /// - Returns: An array of `BookItemModel` objects.
    public func getBookItems() async throws -> [BookItemModel] {
        LoggingAPI.shared.log("Fetching Book items", level: .info)
        
        let fileURL = getJSONFileURL()
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            LoggingAPI.shared.log("BookItems.json not found at \(fileURL.path). Returning empty array.", level: .info)
            return []
        }
        
        do {
            LoggingAPI.shared.log("Reading data from \(fileURL.path)", level: .info)
            let data = try Data(contentsOf: fileURL)
            
            guard !data.isEmpty else {
                LoggingAPI.shared.log("BookItems.json is empty. Returning empty array.", level: .info)
                return []
            }
            
            LoggingAPI.shared.log("Data read successfully from \(fileURL.path)", level: .info)
            let databaseItems = try JSONDecoder().decode([BookDataBaseModel].self, from: data)
            LoggingAPI.shared.log("Decoded \(databaseItems.count) items from JSON data", level: .info)
            
            return databaseItems.map { $0.toBookItemModel() }
        } catch {
            LoggingAPI.shared.log("Failed to read or decode data from BookItems.json: \(error)", level: .error)
            throw error
        }
    }
    
    /// Saves a Book item to the JSON file.
    /// - Parameter item: The `BookItemModel` to save.
    public func saveBookItem(_ item: BookItemModel) async throws {
        LoggingAPI.shared.log("Saving Book item with id \(item.id)", level: .info)
        
        let fileURL = getJSONFileURL()
        var items: [BookItemModel]
        
        do {
            items = try await getBookItems()
        } catch {
            LoggingAPI.shared.log("Failed to fetch existing Book items. Initializing with an empty array.", level: .info)
            items = []
        }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            LoggingAPI.shared.log("Found existing item with id \(item.id). Updating item.", level: .info)
            items[index] = item
        } else {
            LoggingAPI.shared.log("No existing item found with id \(item.id). Adding new item.", level: .info)
            items.append(item)
        }
        
        let databaseItems = items.map { $0.toBookDataBaseModel() }
        let jsonData = try JSONEncoder().encode(databaseItems)
        LoggingAPI.shared.log("Encoded items to JSON data", level: .info)
        
        try jsonData.write(to: fileURL, options: .atomic)
        LoggingAPI.shared.log("Saved JSON data to \(fileURL.path)", level: .info)
        
        // Notify change
        changeSubject.send()
    }
    
    /// Checks if a Book item with the specified ID exists in the JSON file.
    /// - Parameter id: The ID of the Book item to check.
    /// - Returns: A Boolean indicating whether the Book item exists.
    public func isBookItemExist(with id: String) async throws -> Bool {
        LoggingAPI.shared.log("Checking if Book item exists with id \(id)", level: .info)
        
        let items = try await getBookItems()
        let exists = items.contains { $0.id == id }
        
        if (exists) {
            LoggingAPI.shared.log("Book item with id \(id) exists", level: .info)
        } else {
            LoggingAPI.shared.log("No Book item found with id \(id)", level: .info)
        }
        
        return exists
    }
    
    /// Retrieves the IDs of all Book items from the JSON file.
    /// - Returns: An array of strings representing the IDs of the Book items.
    public func getBookItemIDs() async throws -> [String] {
        LoggingAPI.shared.log("Fetching Book item IDs", level: .info)
        
        let items = try await getBookItems()
        let ids = items.map { $0.id }
        
        LoggingAPI.shared.log("Fetched \(ids.count) Book item IDs", level: .info)
        
        return ids
    }
    
    /// Updates an existing Book item in the JSON file.
    /// - Parameter updatedItem: The `BookItemModel` containing the updated data.
    public func updateBookItem(_ updatedItem: BookItemModel) async throws {
        LoggingAPI.shared.log("Updating Book item with id \(updatedItem.id)", level: .info)
        
        let fileURL = getJSONFileURL()
        var items = try await getBookItems()
        
        guard let index = items.firstIndex(where: { $0.id == updatedItem.id }) else {
            LoggingAPI.shared.log("Item with id \(updatedItem.id) not found. Aborting update.", level: .info)
            throw NSError(domain: "BookItemNotFound", code: 404, userInfo: nil)
        }
        
        items[index] = updatedItem
        
        let databaseItems = items.map { $0.toBookDataBaseModel() }
        let jsonData = try JSONEncoder().encode(databaseItems)
        LoggingAPI.shared.log("Encoded updated items to JSON data", level: .info)
        
        try jsonData.write(to: fileURL, options: .atomic)
        LoggingAPI.shared.log("Saved updated JSON data to \(fileURL.path)", level: .info)
        
        // Notify change
        changeSubject.send()
    }
    
    /// Deletes a Book item from the JSON file by its ID.
    /// - Parameter id: The ID of the Book item to delete.
    public func deleteBookItem(by id: String) async throws {
        LoggingAPI.shared.log("Deleting Book item with id \(id)", level: .info)
        
        let fileURL = getJSONFileURL()
        var items = try await getBookItems()
        
        let initialCount = items.count
        items.removeAll(where: { $0.id == id })
        let finalCount = items.count
        
        LoggingAPI.shared.log("Removed \(initialCount - finalCount) item(s) with id \(id)", level: .info)
        
        let databaseItems = items.map { $0.toBookDataBaseModel() }
        let jsonData = try JSONEncoder().encode(databaseItems)
        
        try jsonData.write(to: fileURL, options: .atomic)
        LoggingAPI.shared.log("Saved updated JSON data to \(fileURL.path)", level: .info)
        
        // Notify change
        changeSubject.send()
    }
}

 

