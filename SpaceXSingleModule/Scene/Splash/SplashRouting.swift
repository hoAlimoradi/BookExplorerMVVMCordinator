//
//  SplashRouting.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//

import UIKit

protocol SplashRouting: CoordinatorRouter {
    func navigateToMainTab()
}

final class SplashRouter: SplashRouting {

    // MARK: - Properties
    internal var coordinator: ProjectCoordinatorProtocol?
    
    // MARK: - Initialize
    init(coordinator: ProjectCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    func navigateToMainTab() {
        coordinator?.navigateToMainTab()
    } 
}


