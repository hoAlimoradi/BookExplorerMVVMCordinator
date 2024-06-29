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
    private let launchAPI: LaunchAPIProtocol
    // MARK: - Initialize
    init(configuration: DetailsModule.Configuration) {
        launchAPI = configuration.launchAPI
    }

    func action(_ handler: DetailsViewModelAction) {
        switch handler {
        case .popUp:
            navigateToMainTab()
        }
    }
    
    //MARK:  navigateToMainTab
    private func navigateToMainTab() {
        route.send(.popUp)
    }
}
