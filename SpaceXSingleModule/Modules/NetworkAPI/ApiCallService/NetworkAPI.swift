//
//  NetworkAPI.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation
import Combine 

public protocol NetworkAPIProtocol {
    func getLaunchItems(by paginationModel: PaginationModel) async throws -> PaginationResult<LaunchItemModel>
}

/// A singleton class that manages network requests and handles authentication errors.
public class NetworkAPI: NetworkAPIProtocol {
    
    // Singleton instance of `NetworkAPI`.
    public static let shared = NetworkAPI()
    
    // Combine cancellables set to manage subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // HTTP client that conforms to `HttpClientManagerProtocol`.
    private let httpClient: HttpClientManagerProtocol
    
    // MARK: - Authentication Error Publisher
    /// Publisher that emits authentication error events.
    public var authenticatioErrorValuePublisher = PassthroughSubject<Bool, Never>()
    
    // Private initializer to enforce singleton pattern.
    private init() {
        httpClient = HttpClientManager.shared
        HttpClientManager.shared.authenticatioErrorValuePublisher
            .sink { [weak self] value in
                self?.authenticatioErrorValuePublisher.send(value)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - API Endpoints Enum
    /// A collection of API endpoints/routes.
    private enum API {
        static var basePath: String =  "https://api.spacexdata.com/v4/" //Environment.current.apiBaseUrl
        static var version: String = "v1"
        static var language = "ENGLISH"
        
        /// Returns the full URL for fetching launch items.
        static var getLaunchItems: String {
            return basePath + "launches"
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
    
    // MARK: - Fetch Launch Items
    /// Fetches the launch items from the API.
    ///
    /// This function asynchronously retrieves the list of launch items.
    ///
    /// - Returns: An array of `LaunchItemModel` objects containing the launch items.
    /// - Throws: An error if there was a problem retrieving the launch items.
    public func getLaunchItems(by paginationModel: PaginationModel) async throws ->  PaginationResult<LaunchItemModel> {
        ///"?limit=\(defaultLimit)&offset=\(offset)")
        let queryItemsParameters = ["limit": paginationModel.size,
                                    "offset": paginationModel.offset] as [String : Any]
        
        let result: LaunchListResponseModel = try await httpClient.get(
            headerFields: getGeneralHeader(),
            endpoint: API.getLaunchItems,
            queryItemsParameters: queryItemsParameters,
            authenticationIsRequired: false,
            checkHTTPStatusCode: true
        )
        
        let launchItems = try await parseLaunchItemResponseModel(result)
        return launchItems
    }
    
    // MARK: - Parse Launch Item Response
    /// Parses the API response to generate a list of launch items.
    ///
    /// This function processes the `LaunchListResponseModel` object to generate a list of launch items.
    /// It checks if the list of data is null or empty and throws an error if necessary.
    ///
    /// - Parameter launchData: The `LaunchListResponseModel` object containing the response from the API.
    /// - Returns: An array of `LaunchItemModel` objects containing the parsed launch items.
    /// - Throws: An error if there was a problem parsing the response or if the response contains an error message.
    private func parseLaunchItemResponseModel(_ launchData: LaunchListResponseModel) async throws -> PaginationResult<LaunchItemModel> {
        if launchData.isEmpty  {
            throw NetworkAPIError.emptyList
        }
        //let items = launchData.compactMap { $0.toLaunchItemModel() }
        // Convert to array of LaunchItemModel
        let items: [LaunchItemModel] = launchData.toLaunchItemModel()
        let paginationResult = PaginationResult(items: items,
                                                  total: items.count)
        return paginationResult
    } 
}

