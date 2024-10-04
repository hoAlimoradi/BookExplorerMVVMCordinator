//
//  SessionConfiguration.swift
 

import Foundation
class SessionConfiguration {
    
    static func configuration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        
        // default timeout for requests. we do specify the timeout in the router for all requests and this value should not
        // really be used except for maybe when we stream videos.
        configuration.timeoutIntervalForRequest = 10.0
        
        // allow background tasks to be tried for up to a week. this value should be kept high or upload tasks are marked as
        // timed out even if they are transmitting data. the important value is the timeoutIntervalForRequest.
        configuration.timeoutIntervalForResource = TimeInterval(7 * 60 * 60 * 24)
        
        configuration.httpShouldUsePipelining = true
        configuration.httpShouldSetCookies = false
        configuration.httpMaximumConnectionsPerHost = 6
        
        let defaultHeaders: [AnyHashable: Any] = ["User-Agent": userAgent]
        //defaultHeaders["Accept-Encoding"] = HTTPHeader.defaultAcceptEncoding.value
        
        configuration.httpAdditionalHeaders = defaultHeaders
        
        let cache = URLCache(memoryCapacity: 0, diskCapacity: 256*1024*1024, diskPath: nil)
        configuration.urlCache = cache
        
        return configuration
    }
    
    static var userAgent: String {
        get {
            let name = "Agent"
            
            return "\(name)"
        }
    }
}
