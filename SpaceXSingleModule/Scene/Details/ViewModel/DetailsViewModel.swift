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
    var launchDetailItemsSubject = CurrentValueSubject<[LaunchKeyValueItemModel], Never>([])
    var favoriteStatusSubject = CurrentValueSubject<FavoriteStatusEnum?, Never>(nil)
    private let launchAPI: LaunchAPIProtocol
    private var isFavorite: Bool
    // MARK: - Initialize
    init(configuration: DetailsModule.Configuration) {
        launchAPI = configuration.launchAPI
        isFavorite = configuration.isFavorite
        launchDetailItemsSubject.send(configuration.launchItemModel.toKeyValueItems())
    }

    func action(_ handler: DetailsViewModelAction) {
        switch handler {
        case .toggleButton:
            toggleButton()
        case .checkIsFavorite:
            checkIsFavorite()
        }
    }
    
    //MARK:  toggleButton
    private func toggleButton() {
        isFavorite.toggle()
        if isFavorite {
            favoriteStatusSubject.send(.favorite)
        } else {
            favoriteStatusSubject.send(.notFavorite)
        }
    }
    
    //MARK:  checkIsFavorite
    private func checkIsFavorite() {
        if isFavorite {
            favoriteStatusSubject.send(.favorite)
        } else {
            favoriteStatusSubject.send(.notFavorite)
        }
    }
}
