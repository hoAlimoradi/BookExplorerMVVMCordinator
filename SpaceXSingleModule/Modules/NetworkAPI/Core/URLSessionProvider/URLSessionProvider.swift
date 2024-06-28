//
//  URLSessionProvider.swift
//  NetworkAPI
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation

/// A final class providing URL session management with optional SSL pinning support.
///
/// This class implements the `URLSessionProviderProtocol` and provides functionality to create URL sessions
/// with or without SSL certificate pinning. It also includes helper methods to validate URL schemes and load
/// local certificates.
internal final class URLSessionProvider: URLSessionProviderProtocol {
    
    /// Constants used within the `URLSessionProvider`.
    private enum Constants {
        static var operationQueue = OperationQueue()
        static var regExIsHttpURL = "((http)://).*"
        static var regExIsHttpsURL = "((https)://).*"
        static var frameworkBundleIdentifier = ""
        static var certFileType = "cer"
        static var certificate = "certificate name"
    }
    
    /// Enum representing possible errors from `URLSessionProvider`.
    enum URLSessionProviderError: Error {
        case emptyLocalCert
    }

    // MARK: - URL Validation Methods

    /// Checks if the given endpoint is an HTTP URL.
    ///
    /// - Parameter endPoint: The endpoint string to check.
    /// - Returns: A boolean indicating whether the endpoint is an HTTP URL.
    private func isHttpURL(endPoint: String?) -> Bool {
        guard let urlString = endPoint, let _ = URL(string: urlString) else { return false }
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [Constants.regExIsHttpURL])
        return predicate.evaluate(with: endPoint)
    }
    
    /// Checks if the given endpoint is an HTTPS URL.
    ///
    /// - Parameter endPoint: The endpoint string to check.
    /// - Returns: A boolean indicating whether the endpoint is an HTTPS URL.
    private func isHttpsURL(endPoint: String?) -> Bool {
        guard let urlString = endPoint, let _ = URL(string: urlString) else { return false }
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [Constants.regExIsHttpsURL])
        return predicate.evaluate(with: endPoint)
    }
   
    // MARK: - Certificate Loading Methods

    /// Loads local SSL certificates.
    ///
    /// This method loads SSL certificates from the app bundle to be used for SSL pinning.
    ///
    /// - Returns: An array of `Data` objects representing the loaded certificates.
    private func loadLocalCert() -> [Data] {
        var localData = [Data]()
        let frameworkBundle = Bundle(identifier: Constants.frameworkBundleIdentifier)
         
        guard let frameworkBundle = frameworkBundle,
              let certumFilePath = frameworkBundle.path(forResource: Constants.certificate, ofType: Constants.certFileType),
              let certumData = try? Data(contentsOf: URL(fileURLWithPath: certumFilePath)) else {
            return localData
        }

        localData.append(certumData)
        return localData
    }
    
    /// Retrieves a list of parent app trust certificates.
    ///
    /// This method returns a list of base64 encoded certificates trusted by the parent app.
    ///
    /// - Returns: An array of strings representing the base64 encoded certificates.
    private func getParentAppTrustCertificateList() -> [String] {
        return []
    }
  
    /// Creates a URL session for a given endpoint with an option to check SSL certificates.
    ///
    /// This method returns a URL session configured for the provided endpoint. If SSL checking is enabled,
    /// it performs SSL pinning using local and parent app trusted certificates.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint string for which the URL session is created.
    ///   - checkSSL: A boolean indicating whether SSL certificate pinning should be enabled.
    /// - Returns: An optional `URLSession` object configured based on the provided parameters.
    func getURLSession(from endpoint: String, checkSSL: Bool) -> URLSession? {
        if !checkSSL || isHttpURL(endPoint: endpoint) {
            return URLSession.shared
        }
        
        if isHttpsURL(endPoint: endpoint) {
            var localCerts = loadLocalCert()
            let parentAppTrustCertificateList = getParentAppTrustCertificateList()
            
            for element in parentAppTrustCertificateList {
                let certificate64 = element.replacingOccurrences(of: "\\", with: "")
                if let certificateData = Data(base64Encoded: certificate64) {
                    localCerts.append(certificateData)
                }
            }
            return NSURLSessionPinningDelegate(trustCertificates: localCerts).session
        }
        
        return nil
    }
}





