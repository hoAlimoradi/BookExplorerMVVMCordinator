//
//  HomeViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Combine
import Foundation

/// The `HomeViewModel` class is responsible for managing the state and interactions
/// for the home screen. It fetches launch data from an API, manages pagination, and handles
/// user actions related to the launch list.
final class HomeViewModel: HomeViewModelProtocol {

    // Add any constants if needed in the future
    private enum Constants {
    }
    
    // MARK: - Properties
    
    /// Publishes the current route action for navigation.
    var route = CurrentValueSubject<HomeRouteAction, Never>(.idleRoute)
    
    /// Publishes the list of launch items.
    var launchListSubject = CurrentValueSubject<[LaunchItemModel], Never>([])
    
    /// Publishes the current fetch state of the home screen.
    var homeFetchState = CurrentValueSubject<HomeFetchState, Never>(.idleLaunch)
    
    private var launchListTotal: Int = 0
    private var seenIds = Set<String>()
    private var launchModels = [LaunchItemModel]()
    private var launchListIsLoadingPage = false
    private var launchListPaginationModel: PaginationModel
    private let launchAPI: LaunchAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `HomeViewModel`.
    ///
    /// - Parameter configuration: The configuration object containing the required dependencies.
    init(configuration: HomeModule.Configuration) {
        self.launchAPI = configuration.launchAPI
        self.launchListPaginationModel = PaginationModel(page: 1)
    }
    
    // MARK: - Methods
    
    /// Handles various actions related to the home screen.
    ///
    /// - Parameter handler: The action to be handled.
    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case .getLaunchs:
            getLaunches()
        case .moreLoadLaunchs:
            loadMoreLaunches()
        case .selectLaunch(let launch):
            selectLaunch(launch)
        }
    }
    
    // MARK: - Private Methods
    
    /// Resets properties related to fetching launches.
    private func resetGetLaunchProperties() {
        launchModels.removeAll()
        seenIds.removeAll()
        launchListPaginationModel.page = 1
        launchListPaginationModel.size = 20
        launchListTotal = 0
    }
    
    /// Fetches the list of launches from the API.
    private func getLaunches() {
        resetGetLaunchProperties()
        launchListIsLoadingPage = true
        homeFetchState.send(.loadingLaunch)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.launchAPI.getLaunchItems(by: launchListPaginationModel)
                self.launchListTotal = result.total
                self.updateLaunchListSubject(by: result.items)
                self.launchListIsLoadingPage = false
                if self.launchModels.isEmpty {
                    self.homeFetchState.send(.emptyLaunch)
                } else {
                    self.homeFetchState.send(.idleLaunch)
                }
                launchListPaginationModel.size = 50
            } catch {
                self.launchListIsLoadingPage = false
                self.launchListSubject.send([])
                switch error {
                case NetworkAPIError.emptyList:
                    self.homeFetchState.send(.emptyLaunch)
                default:
                    self.homeFetchState.send(.failedLaunch(error))
                }
                LoggingAPI.shared.log("getLaunches \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
    
    /// Loads more launches from the API for pagination.
    private func loadMoreLaunches() {
        guard !launchListIsLoadingPage else { return }
        if launchListTotal <= launchModels.count { return }
        launchListPaginationModel.page += 1
        launchListIsLoadingPage = true
        homeFetchState.send(.loadMoreLaunch)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.launchAPI.getLaunchItems(by: self.launchListPaginationModel)
                self.launchListTotal = result.total
                if !result.items.isEmpty {
                    self.updateLaunchListSubject(by: result.items)
                }
                self.launchListIsLoadingPage = false
                self.homeFetchState.send(.idleLaunch)
            } catch {
                self.launchListPaginationModel.page -= 1
                self.launchListIsLoadingPage = false
                self.homeFetchState.send(.idleLaunch)
                LoggingAPI.shared.log("loadMoreLaunches \(error.customLocalizedDescription)", level: .error)
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
        updateLaunchListLocally(by: items)
    }
    private func getStoredLaunchItemIDs() async throws -> Set<String> {
        let ids = try await self.launchAPI.getLaunchItemIDs()
            return Set(ids)
        }
        
        private func filterExistingItems(_ items: [LaunchItemModel]) async throws -> [LaunchItemModel] {
            let storedIDs = try await getStoredLaunchItemIDs()
            let filteredItems = items.filter { storedIDs.contains($0.id) }
            return filteredItems
        }
        
        private func updateLaunchListLocally(by items: [LaunchItemModel]) {
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    let filteredItems = try await self.filterExistingItems(items)
                    try await self.launchAPI.updateLaunchItems(filteredItems)
                    LoggingAPI.shared.log("updateLaunchListLocally success", level: .info)
                } catch {
                    LoggingAPI.shared.log("updateLaunchListLocally error: \(error.localizedDescription)", level: .error)
                }
            }
        }
    
    /// Handles the selection of a launch item.
    ///
    /// - Parameter launch: The launch item that was selected.
    private func selectLaunch(_ launch: LaunchItemModel) {
        LoggingAPI.shared.log("Selected launch: \(String(describing: launch.name))", level: .info)
        route.send(.navigateToDetails(launch))
    }
}
