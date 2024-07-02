//
//  SplashViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
import Combine

/// A protocol defining the required methods for a Splash ViewModel.
protocol SplashViewModelProtocol {
    /// Handles various actions related to the Splash ViewModel.
    /// - Parameter handler: An action handler of type `SplashViewModelAction`.
    func action(_ handler: SplashViewModelAction)
}

/// An enumeration representing the various states of fetching data in the splash view.
enum SplashFetchState: Equatable {
    /// The idle state, indicating no fetch operation is in progress.
    case idle
    
    /// The loading state, indicating a fetch operation is in progress.
    case loading
    
    /// The success state, indicating the fetch operation completed successfully.
    /// - Parameter message: An optional success message.
    case success(String?)
    
    /// The failed state, indicating that the fetch operation encountered an error.
    /// - Parameter error: The error that occurred during the fetch operation.
    case failed(Error)
    
    /// Compares two `SplashFetchState` values for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side value to compare.
    ///   - rhs: The right-hand side value to compare.
    /// - Returns: A Boolean value indicating whether the two values are equal.
    static func == (lhs: SplashFetchState, rhs: SplashFetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.success(lhsMessage), .success(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

/// An enumeration representing the various routing actions related to the splash view.
enum SplashRouteAction {
    /// The idle route state, indicating no routing action is in progress.
    case idleRoute
    
    /// A routing action to navigate to the main tab.
    case navigateToMainTab
}

/// An enumeration representing the various actions that can be performed in the Splash ViewModel.
enum SplashViewModelAction {
    /// An action to navigate to the main tab.
    case navigateToMainTab
}

