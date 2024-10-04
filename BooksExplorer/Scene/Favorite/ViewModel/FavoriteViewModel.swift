//
//  FavoriteViewModel.swift

import Combine
import Foundation

/// The `FavoriteViewModel` class is responsible for managing the state and interactions
/// for the Favorite screen. It fetches launch data from an API, manages pagination, and handles
/// user actions related to the launch list.
final class FavoriteViewModel: FavoriteViewModelProtocol {

    // Add any constants if needed in the future
    private enum Constants {
    }
    
    // MARK: - Properties
    
    /// Publishes the current route action for navigation.
    var route = CurrentValueSubject<FavoriteRouteAction, Never>(.idleRoute)
    
    /// Publishes the list of book items.
    var bookListSubject = CurrentValueSubject<[BookItemModel], Never>([])
    
    /// Publishes the current fetch state of the Favorite screen.
    var favoriteFetchState = CurrentValueSubject<FavoriteFetchState, Never>(.idleLaunch)
     
    private var seenIds = Set<String>()
    private var bookModels = [BookItemModel]()
    private var bookListIsLoadingPage = false
    private let searchBookAPI: SearchBookAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `FavoriteViewModel`.
    ///
    /// - Parameter configuration: The configuration object containing the required dependencies.
    init(configuration: FavoriteModule.Configuration) {
        self.searchBookAPI = configuration.searchBookAPI
        observeDataBasePublisher()
    }
    deinit {
        cancellables.forEach { $0.cancel() }
        }
    // MARK: - Methods
    
    /// Handles various actions related to the Favorite screen.
    ///
    /// - Parameter handler: The action to be handled.
    func action(_ handler: FavoriteViewModelAction) {
        switch handler {
        case .getBooks:
            getBooks()
        case .selectBook(let book):
            selectBook(book)
 
        case .observeLifecycle(let lifecycleObserver):
            observeLifecycle(with: lifecycleObserver)
        }
    }
    
    // MARK: - Private Methods
    /// Observes lifecycle events and performs specific actions based on the event type.
    /// - Parameter lifecycleEvent: The lifecycle event being observed. Different lifecycle events trigger different actions.
    private func observeLifecycle(with lifecycleEvent: LifecycleEvent) {
        switch lifecycleEvent {
        case .didLoadView:
            getBooks()
        case .willAppearView,
                .didAppearView,
                .willDisappearView,
                .didDisappearView,
                .didBecomeActiveView,
                .willResignActiveView,
                .didEnterBackgroundView,
                .willEnterForegroundView,
                .didReceiveMemoryWarning,
                .willTerminateApplication:
            break
        }
    }
    
    /// Resets properties related to fetching launches.
    private func resetGetLaunchProperties() {
        bookModels.removeAll()
        seenIds.removeAll() 
    }
    
    /// Fetches the list of favorite book items, updates the relevant properties, and handles various fetch states.
    private func getBooks() {
        resetGetLaunchProperties()
        bookListIsLoadingPage = true
        favoriteFetchState.send(.loadingLaunch)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.searchBookAPI.getFavoriteBookItems()
                self.updatebookListSubject(by: result)
                self.bookListIsLoadingPage = false
                if self.bookModels.isEmpty {
                    self.favoriteFetchState.send(.emptyLaunch)
                } else {
                    self.favoriteFetchState.send(.idleLaunch)
                }
            } catch {
                self.bookListIsLoadingPage = false
                self.bookListSubject.send([])
                switch error {
                case NetworkAPIError.emptyList:
                    self.favoriteFetchState.send(.emptyLaunch)
                default:
                    self.favoriteFetchState.send(.failedLaunch(error))
                }
                LoggingAPI.shared.log("getBooks \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
 
    /// Ensures that book items have unique identifiers before adding them to the list.
    ///
    /// - Parameter items: The list of book items to be processed.
    private func ensureUniqueIdentifiers(items: [BookItemModel]) {
        for item in items {
            if !seenIds.contains(item.id) {
                bookModels.append(item)
                seenIds.insert(item.id)
            }
        }
    }
    
    /// Updates the launch list subject with the provided items.
    ///
    /// - Parameter items: The list of book items to be added.
    private func updatebookListSubject(by items: [BookItemModel]) {
        ensureUniqueIdentifiers(items: items)
        bookListSubject.send(bookModels)
    }
    
    /// Handles the selection of a launch item.
    ///
    /// - Parameter launch: The book item that was selected.
    private func selectBook(_ book: BookItemModel) {
        LoggingAPI.shared.log("Selected book: \(book)", level: .info)
        route.send(.navigateToDetails(book))
    }

    /// Observes the `shouldRefreshFavoritePublisher` from the `searchBookAPI` and triggers actions when a database change is notified.
    private func observeDataBasePublisher() {
        searchBookAPI.shouldRefreshreshFavoriteePublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                LoggingAPI.shared.log("searchBookAPI notify Database change.", level: .info)
                self.getBooks()
            }
            .store(in: &cancellables)
    }

}
