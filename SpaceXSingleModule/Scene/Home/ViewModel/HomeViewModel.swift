//
//  HomeViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Combine
import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    private enum Constants {
    }
    
    // MARK: - Properties
    var route = CurrentValueSubject<HomeRouteAction, Never>(.idleRoute)
    var launchListSubject = CurrentValueSubject<[LaunchItemModel], Never>([])
    var homeFetchState = CurrentValueSubject<HomeFetchState, Never>(.idleLaunch)
    
    private var launchListTotal: Int = 0
    private var launchModels = [LaunchItemModel]()
    private var launchListIsLoadingPage = false
    private var launchListPaginationModel: PaginationModel
    private let launchAPI: LaunchAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    init(configuration: HomeModule.Configuration) {
        launchAPI = configuration.launchAPI
        launchListPaginationModel = PaginationModel(page: 1)
    }
    
    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case .navigateToMainTab:
            navigateToMainTab()
        case .getLaunchs:
            getLaunches()
        case .moreLoadLaunchs:
            loadMoreLaunches()
            
        case .selectLaunch(let launch):
            selectLaunch(launch)
        }
    }
    
    // MARK:  navigateToMainTab
    private func navigateToMainTab() {
        route.send(.navigateToMainTab)
    }
    
    private func getLaunches() {
        launchModels.removeAll()
        launchListPaginationModel.page = 1
        launchListIsLoadingPage = true
        homeFetchState.send(.loadingLaunch)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.launchAPI.getLaunchItems(by: launchListPaginationModel)
                self.launchModels = result.items
                self.launchListTotal = result.total ?? 0
                self.launchListIsLoadingPage = false
                
                self.launchListSubject.send(self.launchModels)
                if self.launchModels.isEmpty {
                    self.homeFetchState.send(.emptyLaunch)
                } else {
                    self.homeFetchState.send(.idleLaunch)
                }
            } catch {
                self.launchListIsLoadingPage = false
                self.launchListSubject.send([])
                self.homeFetchState.send(.failedLaunch(error))
                
                LoggingAPI.shared.log("getLaunches \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
    
    private func loadMoreLaunches() {
        guard !launchListIsLoadingPage, launchModels.count < launchListTotal else { return }
        launchListPaginationModel.page += 1
        launchListIsLoadingPage = true
        homeFetchState.send(.loadMoreLaunch)
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.launchAPI.getLaunchItems(by: launchListPaginationModel)
                if !result.items.isEmpty {
                    self.launchModels.append(contentsOf: result.items)
                    self.launchListSubject.send(self.launchModels)
                }
                self.launchListIsLoadingPage = false
                self.homeFetchState.send(.idleLaunch)
            } catch {
                self.launchListIsLoadingPage = false
                self.homeFetchState.send(.failedLaunch(error))
                LoggingAPI.shared.log("loadMoreLaunches \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
    
    //MARK: selectLaunch
        private func selectLaunch(_ launch: LaunchItemModel) {
            // Perform the action when a launch item is selected.
            // For example, navigating to the details screen or taking a picture.
            print("Selected launch: \(String(describing: launch.name))")
        }
}

