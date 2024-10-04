//
//  WebLogger.swift
 
import Foundation
import Sentry

/// Struct implementing `WebLoggerProtocol` for logging errors and request/response information.
internal class WebLogger: WebLoggerProtocol {
    
    /// Constants used within the `WebLogger`.
    private enum Constants {
        static var tagKeyAPICall = "HttpClientManagerAPICall"
        static var tagKeyAPIResponse = "HttpClientManagerAPIResponse"
        static var mainThreadName = "Main"
        static var defaultThreadName = "-"
        static var fileKey = "File name"
        static var functionKey = "Function name"
        static var lineKey = "Line number"
        static var threadKey = "Thread"
        static var queryItemsKey = "QueryItemsParameters"
        static var httpMethodKey = "httpMethodType"
        static var endpointKey = "Endpoint"
        static var authenticationKey = "AuthenticationIsRequired"
        static var errorObjectKey = "ErrorObject"
        static var errorDescriptionKey = "ErrorCustomDescription"
        static var headersKey = "httpHeaders"
        static var bodyKey = "httpBody"
        static var dateKey = "Date"
        static var statusCodeKey = "StatusCode"
        static var descriptionKey = "Description"
        static var sendBirdErrorMessage = "SendBird error - \(fileKey):"
        static var apiCall = "API call"
        static var endpointCalledMessage = "An endpoint is called, "
        static var apiCallResponse = "API call response,"
        static var errorFromURLMessage = "An error has occurred from this url: "
    }
    
    /// Sends an error log with the specified file path, line number, and function name.
    ///
    /// - Parameters:
    ///   - filePath: The file path where the error occurred.
    ///   - line: The line number where the error occurred.
    ///   - funcName: The name of the function where the error occurred.
    func sendError(filePath: String, line: Int?, funcName: String?) {
        let thread = Thread.current.isMainThread ? Constants.mainThreadName : Thread.current.name ?? Constants.defaultThreadName
        let fileName = (filePath.components(separatedBy: "/").last ?? "").components(separatedBy: ".").first ?? ""
        
        let event = Event(level: .error)
        event.message = SentryMessage(formatted: "\(Constants.sendBirdErrorMessage) \(fileName)")
        
        event.tags = [Constants.tagKeyAPICall: Constants.apiCall]
        event.extra = [
            Constants.functionKey: funcName ?? "",
            Constants.lineKey: "\(line ?? 0)",
            Constants.threadKey: thread
        ]
        
        SentrySDK.capture(event: event)
    }
    
    /// Sends error information to Sentry with detailed request parameters.
    ///
    /// - Parameters:
    ///   - httpMethodType: The HTTP method type of the request.
    ///   - endpoint: The endpoint URL of the request.
    ///   - queryItemsParameters: The query parameters of the request.
    ///   - authenticationIsRequired: A flag indicating if authentication is required.
    ///   - tagKey: The key for the tag.
    ///   - tagValue: The value for the tag.
    ///   - error: The error that occurred.
    ///   - message: The error message.
    func sendErrorToSentry(httpMethodType: String,
                           endpoint: String,
                           queryItemsParameters: [String: Any]?,
                           authenticationIsRequired: Bool,
                           tagKey: String,
                           tagValue: String,
                           error: Error,
                           message: String) {
        let event = Event(level: .error)
        event.message = SentryMessage(formatted: message)
        var stringRepresentation = ""
        stringRepresentation += "\(tagValue) "
        stringRepresentation += "\(Constants.httpMethodKey): \(httpMethodType) "
        stringRepresentation += "\(Constants.endpointKey): \(endpoint) "
        
        event.tags = [tagKey: stringRepresentation]
        event.extra = [
            Constants.httpMethodKey: httpMethodType,
            Constants.endpointKey: endpoint,
            Constants.queryItemsKey: queryItemsParameters ?? [:],
            Constants.authenticationKey: authenticationIsRequired,
            Constants.errorObjectKey: "\(error)",
            Constants.errorDescriptionKey: error.customLocalizedDescription,
        ]
        SentrySDK.capture(event: event)
    }
    
    /// Sends request information to Sentry.
    ///
    /// - Parameter urlRequest: The URL request to log.
    func sendRequestInfoToSentry(with urlRequest: URLRequest) {
        let event = Event(level: .info)
        let endpoint = urlRequest.url?.absoluteString ?? ""
        let method = urlRequest.httpMethod ?? ""
        event.message = SentryMessage(formatted: "\(Constants.endpointCalledMessage) \(endpoint).")
        
        var tagValue = "\(Constants.apiCall), "
        tagValue += "\(Constants.httpMethodKey): \(method), "
        tagValue += "\(Constants.endpointKey): \(endpoint)"
        
        event.tags = [Constants.tagKeyAPICall: tagValue]
        event.extra = [
            Constants.httpMethodKey: method,
            Constants.endpointKey: endpoint,
            Constants.queryItemsKey: "",
            Constants.headersKey: "",
            Constants.bodyKey: "",
            Constants.dateKey: "\(Date().toStringWithTimezone(timeZoneIdentifier: TimeZone.current.identifier))"
        ]
        
        if let url = urlRequest.url, let urlComponent = URLComponents(string: url.absoluteString),
           let queryItems = urlComponent.queryItems {
            var items: [String: String] = [:]
            queryItems.forEach { item in
                items[item.name] = item.value
            }
            event.extra?[Constants.queryItemsKey] = items
        }
        
        if let headers = urlRequest.allHTTPHeaderFields {
            event.extra?[Constants.headersKey] = headers
        }
        
        if let body = urlRequest.httpBody {
            event.extra?[Constants.bodyKey] = String(data: body, encoding: .utf8)
        }
        
        SentrySDK.capture(event: event)
    }
    
    /// Sends response information to Sentry.
    ///
    /// - Parameter response: The HTTP response to log.
    func sendResponseInfoToSentry(with response: HTTPURLResponse) {
        let event = Event(level: .info)
        let url = response.url?.absoluteString ?? ""
        event.message = SentryMessage(formatted: "\(Constants.errorFromURLMessage) \(url).")
        
        var tagValue = Constants.apiCallResponse
        tagValue += "\(Constants.endpointKey): \(url)"
        
        event.tags = [Constants.tagKeyAPIResponse: tagValue]
        event.extra = [
            Constants.statusCodeKey: response.statusCode,
            Constants.descriptionKey: response.description,
            Constants.dateKey: "\(Date().toStringWithTimezone(timeZoneIdentifier: TimeZone.current.identifier))"
        ]
        
        SentrySDK.capture(event: event)
    }
}

 
