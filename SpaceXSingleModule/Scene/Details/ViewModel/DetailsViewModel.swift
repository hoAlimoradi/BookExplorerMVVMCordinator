//
//  DetailsViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Combine
import Foundation

final class DetailsViewModel: DetailsViewModelProtocol {

    private enum Constants {
    }

    // MARK: - Properties
    var route = CurrentValueSubject<DetailsRouteAction, Never>(.idleRoute)
    private let launcheAPI: LauncheAPIProtocol
    // MARK: - Initialize
    init(configuration: DetailsModule.Configuration) {
        launcheAPI = configuration.launcheAPI
    }

    func action(_ handler: DetailsViewModelAction) {
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
