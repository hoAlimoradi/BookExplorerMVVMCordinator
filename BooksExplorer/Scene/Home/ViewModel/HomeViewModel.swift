//
//  HomeViewModel.swift
//

import Combine
import Foundation

/// The `HomeViewModel` class is responsible for managing the state and interactions
/// for the home screen. It fetches Book data from an API, manages pagination, and handles
/// user actions related to the Book list.
final class HomeViewModel: HomeViewModelProtocol {
    // Add any constants if needed in the future
    private enum Constants {
    }
    
    // MARK: - Properties
    
    /// Publishes the current route action for navigation.
    var route = CurrentValueSubject<HomeRouteAction, Never>(.idleRoute)
    
    /// Publishes the list of book items.
    var bookListSubject = CurrentValueSubject<[BookItemModel], Never>([])
    
    /// Publishes the current fetch state of the home screen.
    var homeFetchState = CurrentValueSubject<HomeFetchState, Never>(.idleBook)
    
    private var bookListTotal: Int = 0
    private var seenIds = Set<String>()
    private var bookModels = [BookItemModel]()
    private var bookListIsLoadingPage = false
    private var bookListPaginationModel: PaginationModel
    private var searchBookAPI: SearchBookAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    private var queryContent: String? = nil
    // MARK: - Initialization
    
    /// Initializes a new instance of `HomeViewModel`.
    ///
    /// - Parameter configuration: The configuration object containing the required dependencies.
    init(configuration: HomeModule.Configuration) {
        self.searchBookAPI = configuration.searchBookAPI
        self.bookListPaginationModel = PaginationModel(page: 1)
    }
    
    // MARK: - Methods
    /// Handles various actions related to the home screen.
    ///
    /// - Parameter handler: The action to be handled.
    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case .getBooks:
            search(by: nil)
        case .moreLoadBooks:
            moreLoadBooks()
        case .selectBook(let book):
            selectBook(book)
        case .search(let query):
            search(by: query)
            
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
            search(by: nil)
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
    /// Resets properties related to fetching Bookes.
    private func resetGetBookProperties() {
        bookModels.removeAll()
        seenIds.removeAll()
        bookListPaginationModel.page = 1
        bookListPaginationModel.size = 20
        bookListTotal = 0
        queryContent?.removeAll()
    }
 
    /// Search the list of Bookes from the API.
    private func search(by query: String?) {
        resetGetBookProperties()
        queryContent = query
        bookListIsLoadingPage = true
        homeFetchState.send(.loadingBook)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.searchBookAPI.searchBooks(by: queryContent,
                                                                      pagination: bookListPaginationModel)
                self.bookListTotal = result.total
                self.updatebookListSubject(by: result.items)
                self.bookListIsLoadingPage = false
                if self.bookModels.isEmpty {
                    self.homeFetchState.send(.emptyBook)
                } else {
                    self.homeFetchState.send(.idleBook)
                }
            } catch {
                self.bookListIsLoadingPage = false
                self.bookListSubject.send([])
                switch error {
                case NetworkAPIError.emptyList:
                    self.homeFetchState.send(.emptyBook)
                default:
                    self.homeFetchState.send(.failedBook(error))
                }
                LoggingAPI.shared.log("getBooks \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
    
    
    /// Loads more Bookes from the API for pagination.
    private func moreLoadBooks() {
        guard !bookListIsLoadingPage else { return }
        if bookListTotal <= bookModels.count { return }
        bookListPaginationModel.page += 1
        bookListIsLoadingPage = true
        homeFetchState.send(.loadMoreBook)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.searchBookAPI.searchBooks(by: queryContent, pagination: bookListPaginationModel)
                self.bookListTotal = result.total
                if !result.items.isEmpty {
                    self.updatebookListSubject(by: result.items)
                }
                self.bookListIsLoadingPage = false
                self.homeFetchState.send(.idleBook)
            } catch {
                self.bookListPaginationModel.page -= 1
                self.bookListIsLoadingPage = false
                self.homeFetchState.send(.idleBook)
                LoggingAPI.shared.log("moreLoadBooks \(error.customLocalizedDescription)", level: .error)
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
    
    /// Updates the Book list subject with the provided items.
    ///
    /// - Parameter items: The list of book items to be added.
    private func updatebookListSubject(by items: [BookItemModel]) {
        ensureUniqueIdentifiers(items: items)
        bookListSubject.send(bookModels)
        updateBookListLocally(by: items)
    }
    private func getStoredBookItemIDs() async throws -> Set<String> {
        let ids = try await self.searchBookAPI.getBookItemIDs()
        return Set(ids)
    }
    
    private func filterExistingItems(_ items: [BookItemModel]) async throws -> [BookItemModel] {
        let storedIDs = try await getStoredBookItemIDs()
        let filteredItems = items.filter { storedIDs.contains($0.id) }
        return filteredItems
    }
    
    private func updateBookListLocally(by items: [BookItemModel]) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let filteredItems = try await self.filterExistingItems(items)
                try await self.searchBookAPI.updateBookItems(filteredItems)
                LoggingAPI.shared.log("updateBookListLocally success", level: .info)
            } catch {
                LoggingAPI.shared.log("updateBookListLocally error: \(error.localizedDescription)", level: .error)
            }
        }
    }
    
    /// Handles the selection of a Book item.
    ///
    /// - Parameter Book: The book item that was selected.
    private func selectBook(_ book: BookItemModel) {
        LoggingAPI.shared.log("Selected  : \(book)", level: .info)
        route.send(.navigateToDetails(book))
    }
}

