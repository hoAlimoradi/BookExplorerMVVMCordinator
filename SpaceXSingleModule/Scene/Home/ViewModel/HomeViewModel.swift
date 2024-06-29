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
    private let launcheAPI: LauncheAPIProtocol
    // MARK: - Initialize
    init(configuration: HomeModule.Configuration) {
        launcheAPI = configuration.launcheAPI
    }

    func action(_ handler: HomeViewModelAction) {
        switch handler {
        case .navigateToMainTab:
            navigateToMainTab()
        }
    }
    
    //MARK:  navigateToMainTab
    private func navigateToMainTab() {
        route.send(.navigateToMainTab)
    }
}

