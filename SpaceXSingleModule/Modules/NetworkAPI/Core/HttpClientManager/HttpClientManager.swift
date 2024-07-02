//
//  HttpClientManager.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
import Combine
import UIKit

/// A manager class responsible for handling HTTP requests and responses.
internal class HttpClientManager: HttpClientManagerProtocol {
    
    /// Constants used within the `HttpClientManager` class.
    enum Constants {
        static var httpMethodGET = "GET"
        static var httpMethodPOST = "POST"
        static var applicationJson = "application/json"
        static var accept = "accept"
        static var contentType = "Content-Type"
        static var timeoutTimeInterval: TimeInterval = 60.0
    }
    
    /// Publisher that emits authentication error events.
    public var authenticatioErrorValuePublisher = PassthroughSubject<Bool, Never>()
    
    /// Publisher that emits user banned error events.
    public var userBannedErrorValuePublisher = PassthroughSubject<Bool, Never>()
    
    /// Shared singleton instance of `HttpClientManager`.
    public static let shared: HttpClientManager = .init()
    
    /// URLSession provider for creating URL sessions.
    private var provideURLSessionAPI: URLSessionProviderProtocol
    
    /// UserDefaults API for managing user defaults.
    private let userDefaultsAPI: UserDefaultsProtocol
    
    /// Logger for web-related activities.
    private var webLogger: WebLoggerProtocol
    
    /// Logger for capturing request/response logs.
    private var reponseLog = URLRequestLoggableImpl()
    
    /// Set to manage Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    /// NSCache for caching images.
    private var imageCache = NSCache<NSURL, UIImage>()
    
    /// Initializes an instance of `HttpClientManager`.
    internal init() {
        webLogger = WebLogger()
        userDefaultsAPI = UserDefaults.standard
        provideURLSessionAPI = URLSessionProvider()
        NetworkMonitor.shared.startMonitoring()
    }
    
    /// Deinitializes the `HttpClientManager` instance.
    deinit {
        NetworkMonitor.shared.stopMonitoring()
    }
    
    //MARK: - ssl pinning chech
    /// Provides a URLSession instance for a given endpoint.
    ///
    /// - Parameter endpoint: The endpoint for which the URLSession is needed.
    /// - Returns: An optional URLSession instance.
    private func provideSesseion(endpoint: String) -> URLSession? {
        return provideURLSessionAPI.getURLSession(from: endpoint, checkSSL: false)
    }
    
    /// Performs an HTTP GET request and decodes the response into a generic type `T`.
    ///
    /// - Parameters:
    ///   - headerFields: Optional array of header fields for the request.
    ///   - endpoint: The endpoint or URL string for the GET request.
    ///   - queryItemsParameters: Optional dictionary of query items parameters.
    ///   - authenticationIsRequired: Boolean flag indicating if authentication is required for the request.
    ///   - checkHTTPStatusCode: Boolean flag indicating if HTTP status code needs to be checked.
    /// - Returns: A decoded instance of type `T` representing the response data.
    /// - Throws: An error if the request fails or if decoding the response data fails.
    public func get<T>(headerFields: [HeaderFieldModel]?,
                       endpoint: String,
                       queryItemsParameters: [String : Any]?,
                       authenticationIsRequired: Bool,
                       checkHTTPStatusCode: Bool) async throws -> T where T : Decodable, T : Encodable {
        
        guard let urlComponent = URLComponents(string: endpoint), var link = urlComponent.url else {
            throw HttpClientManagerAPIError.invalidURLComponents
        }
        if let queryItemsParameters = queryItemsParameters {
            link.appendQueryItems(parameters: queryItemsParameters)
        }
        
        var request = URLRequest(url: link,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: Constants.timeoutTimeInterval)
        request.httpMethod = Constants.httpMethodGET
        request.addValue(Constants.applicationJson, forHTTPHeaderField: Constants.accept)
        if (headerFields != nil) {
            for headerField in headerFields! {
                request.addValue(headerField.value, forHTTPHeaderField: headerField.key)
            }
        }
        
        if(!NetworkMonitor.shared.isReachable) {
            throw HttpClientManagerAPIError.networkNotReachable
        }
        guard let session = provideSesseion(endpoint: endpoint) else {
            throw HttpClientManagerAPIError.unableToProvideURLSession
        }
        
        let result:T = try await apiCall(request: request,
                                         urlSession: session,
                                         checkHTTPStatusCode: checkHTTPStatusCode)
        return result
    } 
    
    /// Performs an HTTP POST request and decodes the response into a generic type `T`.
    ///
    /// - Parameters:
    ///   - headerFields: Optional array of header fields for the request.
    ///   - requstBody: Optional data representing the body of the request.
    ///   - queryItemsParameters: Optional dictionary of query items parameters.
    ///   - endpoint: The endpoint or URL string for the POST request.
    ///   - authenticationIsRequired: Boolean flag indicating if authentication is required for the request.
    ///   - checkHTTPStatusCode: Boolean flag indicating if HTTP status code needs to be checked.
    /// - Returns: A decoded instance of type `T` representing the response data.
    /// - Throws: An error if the request fails or if decoding the response data fails.
    public func post<T>(headerFields: [HeaderFieldModel]?,
                        requstBody: Data?,
                        queryItemsParameters: [String : Any]?,
                        endpoint: String,
                        authenticationIsRequired: Bool,
                        checkHTTPStatusCode: Bool) async throws -> T where T : Decodable, T : Encodable {
        guard let urlComponent = URLComponents(string: endpoint), var link = urlComponent.url else {
            throw HttpClientManagerAPIError.invalidURLComponents
        }
        if let queryItemsParameters = queryItemsParameters {
            link.appendQueryItems(parameters: queryItemsParameters)
        }
        var request = URLRequest(url: link, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: Constants.timeoutTimeInterval)
        request.httpMethod = Constants.httpMethodPOST
        request.addValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
        
        if (headerFields != nil) {
            for headerField in headerFields! {
                request.addValue(headerField.value, forHTTPHeaderField: headerField.key)
            }
        }
         
        if(requstBody != nil) {
            request.httpBody = requstBody
        }
        
        if(!NetworkMonitor.shared.isReachable) {
            throw HttpClientManagerAPIError.networkNotReachable
        }
        guard let session = provideSesseion(endpoint: endpoint) else {
            throw HttpClientManagerAPIError.unableToProvideURLSession
        }
        
        let result:T = try await apiCall(request: request,
                                         urlSession: session,
                                         checkHTTPStatusCode: checkHTTPStatusCode)
        return result
    } 

    // MARK: Fetch Generic Type
    /// - Parameters:
    ///   - request: The URLRequest instance representing the API request.
    ///   - urlSession: The URLSession instance used to execute the request.
    ///   - checkHTTPStatusCode: Boolean flag indicating if HTTP status code needs to be checked.
    /// - Returns: A decoded instance of type `T` representing the response data.
    /// - Throws: An error if the request fails or if decoding the response data fails.
    private func apiCall<T: Codable>(request: URLRequest,
                                     urlSession: URLSession,
                                     checkHTTPStatusCode: Bool) async throws -> T  {
        request.debug()
        
        let (data, response) = try await urlSession.data(for: request)
        
        reponseLog.logResponse(response as? HTTPURLResponse, data: data, error: nil, HTTPMethod: request.httpMethod)
        guard let response = response as? HTTPURLResponse else {
            LoggingAPI.shared.log("HttpClientManagerAPIError. \((request.debugDescription))", level: .info)
            throw HttpClientManagerAPIError.generic("Something went wrong, please try again")
        }
        
        //401 , 5... -> not pars
        if (checkHTTPStatusCode) {
            switch (response.statusCode) {
            case HTTPStatusCode.notAcceptable.rawValue:
                triggerUserBannedObserverError()
                LoggingAPI.shared.log("HttpClientManagerAPIError. \((request.debugDescription))", level: .info)
                webLogger.sendResponseInfoToSentry(with: response)
                webLogger.sendRequestInfoToSentry(with: request)
                throw (HttpClientManagerAPIError.notAcceptable)
                
            case HTTPStatusCode.unauthorized.rawValue:
                triggerExpiredAccessTokenObserverError()
                LoggingAPI.shared.log(" unauthorized. \((request.debugDescription))", level: .error)
                webLogger.sendResponseInfoToSentry(with: response)
                webLogger.sendRequestInfoToSentry(with: request)
                throw (HttpClientManagerAPIError.unauthorized)
                
                //5XX
            case HTTPStatusCode.internalServerError.rawValue,
                HTTPStatusCode.notImplemented.rawValue,
                HTTPStatusCode.badGateway.rawValue,
                HTTPStatusCode.serviceUnavailable.rawValue,
                HTTPStatusCode.gatewayTimeout.rawValue,
                HTTPStatusCode.httpVersionNotSupported.rawValue :
                
               // LoggingAPI.shared.log(" HttpClientManagerAPIError.  5XX . \((request.debugDescription))", level: .error)
                webLogger.sendResponseInfoToSentry(with: response)
                webLogger.sendRequestInfoToSentry(with: request)
                throw (HttpClientManagerAPIError.generic("gatewayTimeout"))
                
            case HTTPStatusCode.badRequest.rawValue,
                HTTPStatusCode.notFound.rawValue,
                HTTPStatusCode.forbidden.rawValue,
                HTTPStatusCode.conflict.rawValue,
                HTTPStatusCode.expectationFailed.rawValue,
                HTTPStatusCode.tooManyRequest.rawValue:
                
                let clietErrorDescription = parsClientMessageError(data)
                LoggingAPI.shared.log("HttpClientManagerAPIError. badRequest\(String(describing: clietErrorDescription)) ", level: .error)
                webLogger.sendResponseInfoToSentry(with: response)
                webLogger.sendRequestInfoToSentry(with: request)
                throw (HttpClientManagerAPIError.metaClientMessageError(clietErrorDescription))
                
                
            case HTTPStatusCode.ok.rawValue, HTTPStatusCode.created.rawValue:
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    return result
                } catch(let error) {
                    switch error {
                    case let decodingError as DecodingError:
                        let detailedDescription = decodingError.detailedDescription
                        LoggingAPI.shared.log("detailedDescription : \(detailedDescription) ", level: .error)
                        throw (HttpClientManagerAPIError.deserialize(detailedDescription))
                    default:
                        throw (HttpClientManagerAPIError.deserialize(error.customLocalizedDescription))
                    }
                }
                
            default:
                LoggingAPI.shared.log("HttpClientManagerAPIError.noContent", level: .warning)
                webLogger.sendResponseInfoToSentry(with: response)
                webLogger.sendRequestInfoToSentry(with: request)
                throw (HttpClientManagerAPIError.noContent)
            }
        } else {
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch(let error) {
                webLogger.sendResponseInfoToSentry(with: response)
                webLogger.sendRequestInfoToSentry(with: request)
                switch error {
                case let decodingError as DecodingError:
                    let detailedDescription = decodingError.detailedDescription
                   // LoggingAPI.shared.log("error detailedDescription : \(detailedDescription)", level: .error)
                    throw (HttpClientManagerAPIError.deserialize(detailedDescription))
                default:
                    throw (HttpClientManagerAPIError.deserialize(error.customLocalizedDescription))
                }
            }
        }
    }
    
    /// Parses client message error from the provided JSON data.
    ///
    /// - Parameter jsonData: The JSON data containing client error message.
    /// - Returns: A string representing the parsed client error message.
    private func parsClientMessageError(_ jsonData: Data) -> String {
        guard let model = try? JSONDecoder().decode(String.self, from: jsonData) else {
            LoggingAPI.shared.log("parsClientMessageError is nil", level: .error)
            return "No content was found"
        }
        LoggingAPI.shared.log("parsClientMessageError  \(model)  ", level: .info)
        return model
    }
    
    /// Triggers an observer error for expired access token.
    private func triggerExpiredAccessTokenObserverError() {
        authenticatioErrorValuePublisher.send(true)
        LoggingAPI.shared.log("triggerExpiredAccessTokenObserverError", level: .warning)
         
    }
    
    /// Triggers an observer error for user banned scenario.
    private func triggerUserBannedObserverError() {
        userBannedErrorValuePublisher.send(true)
        LoggingAPI.shared.log("triggerUserBannedObserverError", level: .warning)
    }
}
