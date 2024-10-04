//
//  SplashRouting.swift
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


