//
//  FavoriteViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import Combine
  
/// A protocol defining the required properties and methods for a Favorite ViewModel.
protocol FavoriteViewModelProtocol {
    /// A subject that handles routing actions related to favorites.
    var route: CurrentValueSubject<FavoriteRouteAction, Never> { get }

    /// A subject that holds the list of launch items marked as favorites.
    var launchListSubject: CurrentValueSubject<[LaunchItemModel], Never> { get }

    /// A subject that tracks the state of fetching favorite items.
    var favoriteFetchState: CurrentValueSubject<FavoriteFetchState, Never> { get }

    /// Handles various actions related to the Favorite ViewModel.
    /// - Parameter handler: An action handler of type `FavoriteViewModelAction`.
    func action(_ handler: FavoriteViewModelAction)
}

 
/// An enumeration representing the various states of fetching favorite items.
enum FavoriteFetchState: Equatable {
    /// The idle state, indicating no fetch operation is in progress.
    case idleLaunch
    
    /// The loading state, indicating a fetch operation is in progress.
    case loadingLaunch
    
    /// The empty state, indicating that the fetch operation completed successfully, but no favorite items were found.
    case emptyLaunch
    
    /// The failed state, indicating that the fetch operation encountered an error.
    /// - Parameter error: The error that occurred during the fetch operation.
    case failedLaunch(Error)
    
    /// Compares two `FavoriteFetchState` values for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side value to compare.
    ///   - rhs: The right-hand side value to compare.
    /// - Returns: A Boolean value indicating whether the two values are equal.
    static func == (lhs: FavoriteFetchState, rhs: FavoriteFetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idleLaunch, .idleLaunch),
             (.loadingLaunch, .loadingLaunch),
             (.emptyLaunch, .emptyLaunch):
            return true
        case let (.failedLaunch(lhsError), .failedLaunch(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

/// An enumeration representing the various routing actions related to favorites.
enum FavoriteRouteAction {
    /// The idle route state, indicating no routing action is in progress.
    case idleRoute
    
    /// A routing action to navigate to the details of a specific launch item.
    /// - Parameter launchItem: The launch item model to navigate to details for.
    case navigateToDetails(LaunchItemModel)
}

/// An enumeration representing the various actions that can be performed in the Favorite ViewModel.
enum FavoriteViewModelAction {
    /// An action to fetch the list of launch items.
    case getLaunchs
    
    /// An action to select a specific launch item.
    /// - Parameter launchItem: The launch item model that was selected.
    case selectLaunch(LaunchItemModel)
}



