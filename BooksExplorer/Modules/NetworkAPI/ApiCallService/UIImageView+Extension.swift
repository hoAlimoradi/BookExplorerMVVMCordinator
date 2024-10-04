//
//  UIImageView+Extension.swift
 
import Foundation
import Kingfisher
import UIKit
 
/// A typealias for the result of an image download operation.
public typealias ImageDownloadResult = Result<UIImage, Error>

/// Extension to provide Kingfisher-based image downloading and caching capabilities to UIImageView.
public extension UIImageView {
    
    /// Downloads a public image from the provided URL string and calls the completion handler with the result.
    ///
    /// - Parameters:
    ///   - url: The URL string of the image to download.
    ///   - completion: A closure that receives the result of the image download operation.
    func downloadPublicImage(from url: String, completion: @escaping (ImageDownloadResult) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(.failure(HttpClientManagerAPIError.invalidURLComponents))
            return
        }
        
        self.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))]) { result in
            switch result {
            case .success(let imageResult):
                completion(.success(imageResult.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Downloads a public image from the provided URL string and sets it to the UIImageView.
    ///
    /// - Parameter url: The URL string of the image to download.
    func downloadPublicImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            self.image = UIImage(named: "") // Placeholder image or handle error case
            return
        }
        self.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
    }
}

/// Extension to handle image downloading, caching, and local saving using Kingfisher with UIImageView.
public extension UIImageView {
    
    /// Loads an image from the provided URL string, sets it to the UIImageView, and optionally saves it locally.
    ///
    /// - Parameters:
    ///   - urlString: The URL string of the image to download.
    ///   - fileName: The name of the file to save the image locally.
    ///   - hasIndicator: A flag indicating whether to show an activity indicator during the download.
    func loadKfImage(from urlString: String,
                     fileName: String,
                     hasIndicator: Bool = false) {
        
        if hasIndicator {
            self.kf.indicatorType = .activity
        } else {
            self.kf.indicatorType = .none
        }
        
        guard let url = URL(string: urlString) else {
            LoggingAPI.shared.log("Kingfisher: Invalid URL \(urlString)", level: .error)
            return
        }
        
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(.none)], progressBlock: nil, completionHandler: { result in
            guard let documentsDirectoryURL = try? FileManager.default.url(for: .documentDirectory,
                                                                           in: .userDomainMask,
                                                                           appropriateFor: nil,
                                                                           create: true) else {
                LoggingAPI.shared.log("Kingfisher: Error getting documents directory URL \(urlString)", level: .error)
                return
            }
            
            let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
            
            guard let image = self.image, let pngData = image.pngData() else {
                LoggingAPI.shared.log("Kingfisher: Image or PNG data is nil \(urlString)", level: .error)
                return
            }
            
            do {
                try pngData.write(to: fileURL)
                LoggingAPI.shared.log("Kingfisher: Image saved successfully \(urlString)", level: .info)
            } catch {
                LoggingAPI.shared.log("Kingfisher: Error saving image - \(error) \(urlString)", level: .error)
            }
        })
        
        self.setNeedsLayout()
    }
}

// MARK: - Usage Example
// let imageView = UIImageView()
// imageView.loadKfImage(from: "https://example.com/image.jpg", fileName: "image.png", hasIndicator: true)

/// Enum defining various image animation transitions compatible with Kingfisher.
public enum ImageAnimation {
    case flipFromLeft
    case flipFromRight
    case fade
    
    /// Converts the ImageAnimation to a Kingfisher transition.
    ///
    /// - Parameter duration: The duration of the transition.
    /// - Returns: The Kingfisher ImageTransition corresponding to the ImageAnimation.
    func convert(withDuration duration: TimeInterval) -> ImageTransition {
        switch self {
        case .flipFromLeft:
            return .flipFromLeft(duration)
        case .flipFromRight:
            return .flipFromRight(duration)
        case .fade:
            return .fade(duration)
        }
    }
}

// MARK: - UIImageView Extension for Image Loading and Caching
public extension UIImageView {
    
    /// Sets an image to the UIImageView from the provided URL.
    ///
    /// - Parameter url: The URL of the image to set.
    func setImage(from url: URL) {
        kf.setImage(with: url)
    }

    /// Sets an image to the UIImageView from the provided URL string.
    ///
    /// - Parameter string: The URL string of the image to set.
    func setImage(from string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else { return }
        setImage(from: url)
    }

    /// Cancels the current image download task.
    func cancelDownload() {
        kf.cancelDownloadTask()
    }
}

