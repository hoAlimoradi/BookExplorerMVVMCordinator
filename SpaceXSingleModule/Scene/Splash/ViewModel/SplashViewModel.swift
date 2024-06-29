//
//  SplashViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//

import Combine
import Foundation 

final class SplashViewModel: SplashViewModelProtocol {

    private enum Constants {
    }

    // MARK: - Properties
    var route = CurrentValueSubject<SplashRouteAction, Never>(.idleRoute) 
  
    // MARK: - Initialize
    init(configuration: SplashModule.Configuration) {
    }

    func action(_ handler: SplashViewModelAction) {
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

