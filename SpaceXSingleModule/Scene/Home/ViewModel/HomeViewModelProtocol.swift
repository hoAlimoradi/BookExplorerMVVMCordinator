//
//  HomeViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation
import Combine
 
/// A protocol defining the required properties and methods for a Home ViewModel.
protocol HomeViewModelProtocol: LifecycleEventProtocol {
    /// A subject that handles routing actions related to the home view.
    var route: CurrentValueSubject<HomeRouteAction, Never> { get }

    /// A subject that holds the list of launch items.
    var launchListSubject: CurrentValueSubject<[LaunchItemModel], Never> { get }

    /// A subject that holds the current state of fetching launch items.
    var homeFetchState: CurrentValueSubject<HomeFetchState, Never> { get }

    /// Handles various actions related to the Home ViewModel.
    /// - Parameter handler: An action handler of type `HomeViewModelAction`.
    func action(_ handler: HomeViewModelAction)
}

/// An enumeration representing the various states of fetching launch items in the home view.
enum HomeFetchState: Equatable {
    /// The idle state, indicating no fetch operation is in progress.
    case idleLaunch
    
    /// The loading state, indicating a fetch operation is in progress.
    case loadingLaunch
    
    /// The load more state, indicating additional items are being loaded.
    case loadMoreLaunch
    
    /// The empty state, indicating no items were found.
    case emptyLaunch
    
    /// The failed state, indicating that the fetch operation encountered an error.
    /// - Parameter error: The error that occurred during the fetch operation.
    case failedLaunch(Error)
    
    /// Compares two `HomeFetchState` values for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side value to compare.
    ///   - rhs: The right-hand side value to compare.
    /// - Returns: A Boolean value indicating whether the two values are equal.
    static func == (lhs: HomeFetchState, rhs: HomeFetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idleLaunch, .idleLaunch),
             (.loadingLaunch, .loadingLaunch),
             (.loadMoreLaunch, .loadMoreLaunch),
             (.emptyLaunch, .emptyLaunch):
            return true
        case let (.failedLaunch(lhsError), .failedLaunch(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
 
/// An enumeration representing the various routing actions related to the home view.
enum HomeRouteAction {
    /// The idle route state, indicating no routing action is in progress.
    case idleRoute
   
    /// A routing action to navigate to the details of a specific launch item.
    /// - Parameter launchItem: The launch item model to navigate to details for.
    case navigateToDetails(LaunchItemModel)
}


/// An enumeration representing the various actions that can be performed in the Home ViewModel.
enum HomeViewModelAction {
    case observeLifecycle(LifecycleEvent)
    
    /// An action to fetch the list of launch items.
    case getLaunchs
    
    /// An action to load more launch items.
    case moreLoadLaunchs
    
    /// An action to select a specific launch item.
    /// - Parameter launchItem: The launch item model that was selected.
    case selectLaunch(LaunchItemModel)
}
