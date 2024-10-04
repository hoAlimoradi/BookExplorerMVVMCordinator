//
//  HomeRouting.swift
//  

import UIKit

protocol HomeRouting: CoordinatorRouter {
    func navigateToDetials(by BookItemModel: BookItemModel)
}

final class HomeRouter: HomeRouting {

    // MARK: - Properties
    internal var coordinator: ProjectCoordinatorProtocol?
    
    // MARK: - Initialize
    init(coordinator: ProjectCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    func navigateToDetials(by BookItemModel: BookItemModel) {
        coordinator?.navigateToDetails(by: BookItemModel, isFavorite: false)
    }
}

