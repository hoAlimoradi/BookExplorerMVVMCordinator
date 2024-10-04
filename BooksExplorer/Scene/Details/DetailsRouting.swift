//
//  DetailsRouting.swift
//  

import UIKit

protocol DetailsRouting: CoordinatorRouter {
    func openUrl(_ urlString: String?)
}

final class DetailsRouter: DetailsRouting {

    // MARK: - Properties
    internal var coordinator: ProjectCoordinatorProtocol?
    
    // MARK: - Initialize
    init(coordinator: ProjectCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    func openUrl(_ urlString: String?) {
        coordinator?.openUrl(urlString)
    }
}
