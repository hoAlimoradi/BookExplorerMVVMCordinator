//
//  FavoriteRouting.swift

import UIKit

protocol FavoriteRouting: CoordinatorRouter {
    func navigateToDetials(by bookItemModel: BookItemModel)
}

final class FavoriteRouter: FavoriteRouting {

    // MARK: - Properties
    internal var coordinator: ProjectCoordinatorProtocol?
    
    // MARK: - Initialize
    init(coordinator: ProjectCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation Methods
    func navigateToDetials(by bookItemModel: BookItemModel) {
        coordinator?.navigateToDetails(by: bookItemModel, isFavorite: true)
    }
}
