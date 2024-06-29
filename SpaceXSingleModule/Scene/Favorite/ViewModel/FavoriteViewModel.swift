//
//  FavoriteViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Combine
import Foundation

final class FavoriteViewModel: FavoriteViewModelProtocol {

    private enum Constants {
    }

    // MARK: - Properties
    var route = CurrentValueSubject<FavoriteRouteAction, Never>(.idleRoute)
    private let launchAPI: LaunchAPIProtocol
    // MARK: - Initialize
    init(configuration: FavoriteModule.Configuration) {
        launchAPI = configuration.launchAPI
    }

    func action(_ handler: FavoriteViewModelAction) {
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

