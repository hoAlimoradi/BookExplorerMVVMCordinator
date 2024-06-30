//
//  HomeRouting.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import UIKit

protocol HomeRouting: CoordinatorRouter {
    func navigateToDetials(by launchItemModel: LaunchItemModel)
}

final class HomeRouter: HomeRouting {

    // MARK: - Properties
    internal var coordinator: ProjectCoordinatorProtocol?
    
    // MARK: - Initialize
    init(coordinator: ProjectCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    func navigateToDetials(by launchItemModel: LaunchItemModel) {
        coordinator?.navigateToDetails(by: launchItemModel, isFavorite: false)
    }
}

