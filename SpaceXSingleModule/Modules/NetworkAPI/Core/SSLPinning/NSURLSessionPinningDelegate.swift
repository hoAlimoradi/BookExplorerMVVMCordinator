//
//  NSURLSessionPinningDelegate.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation
import Security
 
/// A final class that handles URL session delegation with SSL pinning support.
///
/// This class implements `URLSessionDelegate` to provide SSL certificate pinning functionality
/// during URL session authentication challenges. It compares server certificates against a set
/// of trusted certificates to ensure secure connections.
internal final class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    /// Constants used within the `NSURLSessionPinningDelegate`.
    private enum Constants {
        static let operationQueue = OperationQueue()
        static let frameworkBundleIdentifier = ""
    }
    
    /// The framework bundle.
    private let frameworkBundle = Bundle(identifier: Constants.frameworkBundleIdentifier)
    
    /// The URL session associated with this delegate.
    public var session: URLSession!
    
    /// The list of trusted certificates for SSL pinning.
    private var trustCertificates: [Data]
    
    /// Initializes the `NSURLSessionPinningDelegate` with a set of trusted certificates.
    ///
    /// - Parameter trustCertificates: An array of `Data` objects representing trusted SSL certificates.
    init(trustCertificates: [Data]) {
        self.trustCertificates = trustCertificates
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    /// Handles authentication challenges for the URL session.
    ///
    /// This method is called when the server presents an SSL certificate. It compares the server
    /// certificate against the list of trusted certificates provided during initialization.
    ///
    /// - Parameters:
    ///   - session: The URL session that received the challenge.
    ///   - challenge: The authentication challenge.
    ///   - completionHandler: A closure to handle the challenge response.
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            LoggingAPI.shared.log("Canceling authentication challenge due to invalid authentication method or missing server trust", level: .error)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        var error: CFError?
        let status = SecTrustEvaluateWithError(serverTrust, &error)
        
        if status, let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
            let serverCertificateData = SecCertificateCopyData(serverCertificate)
            let data = CFDataGetBytePtr(serverCertificateData)
            let size = CFDataGetLength(serverCertificateData)
            let serverCertData = NSData(bytes: data, length: size)
            
            for trustCertificate in trustCertificates {
                if serverCertData.isEqual(to: trustCertificate) {
                   // LoggingAPI.shared.log("Server certificate matched trusted certificate.", level: .info)
                    completionHandler(.useCredential, URLCredential(trust: serverTrust))
                    return
                }
            }
            
            LoggingAPI.shared.log("Server certificate did not match any trusted certificates.", level: .warning)
            completionHandler(.cancelAuthenticationChallenge, nil)
        } else {
            if let error = error {
                LoggingAPI.shared.log("Server trust evaluation failed with error: \(error)", level: .error)
            } else {
                LoggingAPI.shared.log("Server trust evaluation failed with unknown error.", level: .error)
            }
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

