//
//  FavoriteRouting.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import UIKit

protocol FavoriteRouting: CoordinatorRouter {
    func navigateToDetials(by launchItemModel: LaunchItemModel)
}

final class FavoriteRouter: FavoriteRouting {

    // MARK: - Properties
    internal var coordinator: ProjectCoordinatorProtocol?
    
    // MARK: - Initialize
    init(coordinator: ProjectCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    func navigateToDetials(by launchItemModel: LaunchItemModel) {
        coordinator?.navigateToDetails(by: launchItemModel, isFavorite: true)
    }
}
