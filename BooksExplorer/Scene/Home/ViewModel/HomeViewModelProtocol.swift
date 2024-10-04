//
//  HomeViewModelProtocol.swift

import Foundation
import Combine
 
/// A protocol defining the required properties and methods for a Home ViewModel.
protocol HomeViewModelProtocol: LifecycleEventProtocol {
    /// A subject that handles routing actions related to the home view.
    var route: CurrentValueSubject<HomeRouteAction, Never> { get }

    /// A subject that holds the list of book items.
    var bookListSubject: CurrentValueSubject<[BookItemModel], Never> { get }

    /// A subject that holds the current state of fetching book items.
    var homeFetchState: CurrentValueSubject<HomeFetchState, Never> { get }

    /// Handles various actions related to the Home ViewModel.
    /// - Parameter handler: An action handler of type `HomeViewModelAction`.
    func action(_ handler: HomeViewModelAction)
}

/// An enumeration representing the various states of fetching book items in the home view.
enum HomeFetchState: Equatable {
    /// The idle state, indicating no fetch operation is in progress.
    case idleBook
    
    /// The loading state, indicating a fetch operation is in progress.
    case loadingBook
    
    /// The load more state, indicating additional items are being loaded.
    case loadMoreBook
    
    /// The empty state, indicating no items were found.
    case emptyBook
    
    /// The failed state, indicating that the fetch operation encountered an error.
    /// - Parameter error: The error that occurred during the fetch operation.
    case failedBook(Error)
    
    /// Compares two `HomeFetchState` values for equality.
    /// - Parameters:
    ///   - lhs: The left-hand side value to compare.
    ///   - rhs: The right-hand side value to compare.
    /// - Returns: A Boolean value indicating whether the two values are equal.
    static func == (lhs: HomeFetchState, rhs: HomeFetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idleBook, .idleBook),
             (.loadingBook, .loadingBook),
             (.loadMoreBook, .loadMoreBook),
             (.emptyBook, .emptyBook):
            return true
        case let (.failedBook(lhsError), .failedBook(rhsError)):
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
   
    /// A routing action to navigate to the details of a specific Book item.
    /// - Parameter bookItem: The book item model to navigate to details for.
    case navigateToDetails(BookItemModel)
}


/// An enumeration representing the various actions that can be performed in the Home ViewModel.
enum HomeViewModelAction { 
    /// An action to observe lifecycle events.
    /// - Parameter event: The lifecycle event being observed.
    case observeLifecycle(LifecycleEvent) 
    
    /// An action to fetch the list of book items.
    case getBooks
    
    case search(String
    )
    /// An action to load more book items.
    case moreLoadBooks
    
    /// An action to select a specific Book item.
    /// - Parameter bookItem: The book item model that was selected.
    case selectBook(BookItemModel)
}
