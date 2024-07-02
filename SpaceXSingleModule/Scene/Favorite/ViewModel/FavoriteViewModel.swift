//
//  FavoriteViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
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
    
    /// Publishes the list of launch items.
    var launchListSubject = CurrentValueSubject<[LaunchItemModel], Never>([])
    
    /// Publishes the current fetch state of the Favorite screen.
    var favoriteFetchState = CurrentValueSubject<FavoriteFetchState, Never>(.idleLaunch)
     
    private var seenIds = Set<String>()
    private var launchModels = [LaunchItemModel]()
    private var launchListIsLoadingPage = false
    private let launchAPI: LaunchAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `FavoriteViewModel`.
    ///
    /// - Parameter configuration: The configuration object containing the required dependencies.
    init(configuration: FavoriteModule.Configuration) {
        self.launchAPI = configuration.launchAPI
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
        case .getLaunchs:
            getLaunches()
        case .selectLaunch(let launch):
            selectLaunch(launch)
        }
    }
    
    // MARK: - Private Methods
    
    /// Resets properties related to fetching launches.
    private func resetGetLaunchProperties() {
        launchModels.removeAll()
        seenIds.removeAll() 
    }
    
    /// Fetches the list of favorite launch items, updates the relevant properties, and handles various fetch states.
    private func getLaunches() {
        resetGetLaunchProperties()
        launchListIsLoadingPage = true
        favoriteFetchState.send(.loadingLaunch)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.launchAPI.getFavoriteLaunchItems()
                self.updateLaunchListSubject(by: result)
                self.launchListIsLoadingPage = false
                if self.launchModels.isEmpty {
                    self.favoriteFetchState.send(.emptyLaunch)
                } else {
                    self.favoriteFetchState.send(.idleLaunch)
                }
            } catch {
                self.launchListIsLoadingPage = false
                self.launchListSubject.send([])
                switch error {
                case NetworkAPIError.emptyList:
                    self.favoriteFetchState.send(.emptyLaunch)
                default:
                    self.favoriteFetchState.send(.failedLaunch(error))
                }
                LoggingAPI.shared.log("getLaunches \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
 
    /// Ensures that launch items have unique identifiers before adding them to the list.
    ///
    /// - Parameter items: The list of launch items to be processed.
    private func ensureUniqueIdentifiers(items: [LaunchItemModel]) {
        for item in items {
            if !seenIds.contains(item.id) {
                launchModels.append(item)
                seenIds.insert(item.id)
            }
        }
    }
    
    /// Updates the launch list subject with the provided items.
    ///
    /// - Parameter items: The list of launch items to be added.
    private func updateLaunchListSubject(by items: [LaunchItemModel]) {
        ensureUniqueIdentifiers(items: items)
        launchListSubject.send(launchModels)
    }
    
    /// Handles the selection of a launch item.
    ///
    /// - Parameter launch: The launch item that was selected.
    private func selectLaunch(_ launch: LaunchItemModel) {
        LoggingAPI.shared.log("Selected launch: \(String(describing: launch.name))", level: .info)
        route.send(.navigateToDetails(launch))
    }

    /// Observes the `shouldRefreshFavoritePublisher` from the `launchAPI` and triggers actions when a database change is notified.
    private func observeDataBasePublisher() {
        launchAPI.shouldRefreshreshFavoriteePublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                LoggingAPI.shared.log("launchAPI notify Database change.", level: .info)
                self.getLaunches()
            }
            .store(in: &cancellables)
    }

}
