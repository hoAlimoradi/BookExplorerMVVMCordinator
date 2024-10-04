//
//  URLRequestLoggableProtocol.swift
 
import Foundation

/// A struct that implements the URLRequestLoggableProtocol.
struct URLRequestLoggableImpl: URLRequestLoggableProtocol {
    /// Flag to enable or disable logging.
    let ENABLELOG = true

    /// Logs the response of a URL request.
    ///
    /// - Parameters:
    ///   - response: The HTTP response received from the request.
    ///   - data: The data received from the request.
    ///   - error: The error received from the request, if any.
    ///   - HTTPMethod: The HTTP method of the request.
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, HTTPMethod: String?) {
        guard ENABLELOG else { return }

        defer {
            LoggingAPI.shared.log("🟦 ========== End logResponse ========== 🟦", level: .info)
        }

        guard let response = response else {
            LoggingAPI.shared.log("🙂 ========== Start logResponse ========== 🙂 \n ❌ NULL Response ERROR: ❌", level: .error)
            return
        }

        var logMessage = "🙂 ========== Start logResponse ========== 🙂\n"
        logMessage += "Request HTTPMethod: `\(String(describing: HTTPMethod))`\n"
        if let url = response.url?.absoluteString {
            logMessage += "Request URL: `\(url)`\nResponse Status Code: `\(response.statusCode)`\n"
        } else {
            LoggingAPI.shared.log("❌ LOG ERROR: ❌ \n Empty URL", level: .error)
        }

        if let error = error {
            LoggingAPI.shared.log("❌ GOT URL REQUEST ERROR: \(error) ❌", level: .error)
        }

        guard let data = data else {
            LoggingAPI.shared.log("❌ Empty Response ERROR: ❌", level: .error)
            return
        }

        if let json = data.prettyPrintedJSONString {
            logMessage += "✅ Response Data: ✅\n\(json)"
        } else {
            let responseDataString: String = String(data: data, encoding: .utf8) ?? "BAD ENCODING"
            logMessage += "❌ Response ERROR: ❌\n\(responseDataString)"
        }

        LoggingAPI.shared.log(logMessage, level: .info)
    }
}

