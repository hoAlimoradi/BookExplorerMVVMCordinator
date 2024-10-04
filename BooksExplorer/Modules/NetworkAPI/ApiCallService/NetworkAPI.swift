//
//  NetworkAPI.swift
 
import Foundation
import Combine 
import UIKit

public protocol NetworkAPIProtocol {
    func searchBooks(by query: String?, pagination: PaginationModel) async throws -> PaginationResult<BookItemModel>
}

/// A singleton class that manages network requests and handles authentication errors.
public class NetworkAPI: NetworkAPIProtocol {
    // Combine cancellables set to manage subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // HTTP client that conforms to `HttpClientManagerProtocol`.
    private let httpClient: HttpClientManagerProtocol
    
    // MARK: - Authentication Error Publisher
    /// Publisher that emits authentication error events.
    public var authenticatioErrorValuePublisher = PassthroughSubject<Bool, Never>()
    
    // internal initializer to enforce singleton pattern.
    init(httpClient: HttpClientManagerProtocol) {
        self.httpClient = httpClient
        HttpClientManager.shared.authenticatioErrorValuePublisher
            .sink { [weak self] value in
                self?.authenticatioErrorValuePublisher.send(value)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - API Endpoints Enum
    /// A collection of API endpoints/routes.
    private enum API {
        static var basePath: String =  "https://openlibrary.org/" //Environment.current.apiBaseUrl
        static var version: String = "v1"
        static var language = "ENGLISH"
        
        /// Returns the full URL for fetching book items.
        static var searchBooks: String {
            return basePath + "search"
        }
    }
    
    // MARK: - General Header
    /// Creates and returns general headers for API requests.
    ///
    /// - Returns: An array of `HeaderFieldModel` containing the version and language.
    fileprivate func getGeneralHeader() -> [HeaderFieldModel] {
        return [
            HeaderFieldModel(key: "version", value: API.version),
            HeaderFieldModel(key: "language", value: API.language)
        ]
    } 
    // Fetch books by title query
    public func searchBooks(by query: String?, pagination: PaginationModel) async throws -> PaginationResult<BookItemModel> {
        var queryItems: [String: Any] = [
            "title": query,
            "page": pagination.page,
            "limit": pagination.size
        ]
        
        let response: BaseApiResponseModel<BookResponseModel> = try await httpClient.get(headerFields: nil,
                                                                                         endpoint: API.searchBooks,
                                                                                         queryItemsParameters: queryItems,
                                                                                         authenticationIsRequired: false,
                                                                                         checkHTTPStatusCode: true)
        
        return try parseBookResponseModel(response)
    }

    private func parseBookResponseModel(_ decodedData: BaseApiResponseModel<BookResponseModel>) throws -> PaginationResult<BookItemModel> {
        guard let booksData = decodedData.docs else {
            throw NetworkAPIError.emptyList
        }
        if booksData.isEmpty {
            throw NetworkAPIError.emptyList
        }
        let items: [BookItemModel] = booksData.compactMap { $0.toBookModel() }
        let paginationResult = PaginationResult(items: items, total: decodedData.baseNumFound)
        return paginationResult
    }
}
 
