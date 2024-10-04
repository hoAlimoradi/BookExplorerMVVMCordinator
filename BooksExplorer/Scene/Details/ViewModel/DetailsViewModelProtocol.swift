//
//  DetailsViewModelProtocol.swift
//  
//
import Foundation
import Combine
import UIKit

/// A protocol defining the required properties and methods for a Details ViewModel.
protocol DetailsViewModelProtocol {
    /// A subject that handles routing actions related to details.
    var route: CurrentValueSubject<DetailsRouteAction, Never> { get }
    
    /// A subject that holds the favorite status of the item.
    var favoriteStatusSubject: CurrentValueSubject<FavoriteStatusEnum?, Never> { get }

    /// A subject that holds the image associated with the details.
    var imageSubject: CurrentValueSubject<UIImage?, Never> { get }

    /// A subject that holds the details of The book item.
    //var bookItemModelSubject: CurrentValueSubject<BookItemModel?, Never>
    var bookKeyValueItemModelsSubject: CurrentValueSubject<[BookKeyValueItemModel]?, Never> { get }
    /// Handles various actions related to the Details ViewModel.
    /// - Parameter handler: An action handler of type `DetailsViewModelAction`.
    func action(_ handler: DetailsViewModelAction)
}


/// An enumeration representing the various states of fetching details.
enum DetailsFetchState: Equatable {
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
    
    /// Compares two `DetailsFetchState` values for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side value to compare.
    ///   - rhs: The right-hand side value to compare.
    /// - Returns: A Boolean value indicating whether the two values are equal.
    static func == (lhs: DetailsFetchState, rhs: DetailsFetchState) -> Bool {
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


/// An enumeration representing the various routing actions related to details.
enum DetailsRouteAction {
    /// The idle route state, indicating no routing action is in progress.
    case idleRoute
    
    /// A routing action to open a URL.
    /// - Parameter url: The URL to be opened.
    case openUrl(String?)
    
    /// A routing action to share or export an item.
    /// - Parameter exportData: The data to be shared or exported.
    case shareExport(String)
}

 
/// An enumeration representing the various actions that can be performed in the Details ViewModel.
enum DetailsViewModelAction {
    /// An action to observe lifecycle events.
    /// - Parameter event: The lifecycle event being observed.
    case observeLifecycle(LifecycleEvent)
    
    /// An action to toggle a button.
    case toggleButton
    
    /// An action to check if an item is marked as favorite.
    case checkIsFavorite
    
    /// An action to toggle the favorite status of an item.
    /// - Parameter itemId: The ID of the item to be toggled.
    case toggleItem(String?)
    
    /// An action to export an item.
    case export
}


/// An enumeration representing the favorite status of an item.
enum FavoriteStatusEnum {
    /// Indicates that the item is marked as favorite.
    case favorite
    
    /// Indicates that the item is not marked as favorite.
    case notFavorite
}

