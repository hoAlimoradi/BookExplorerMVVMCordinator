//
//  FavoriteViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import Combine

protocol FavoriteViewModelProtocol {
    func action(_ handler: FavoriteViewModelAction)
}

enum FavoriteFetchState: Equatable {
    case idle
    case loading
    case success(String?)
    case failed(Error)

    static func == (lhs: FavoriteFetchState, rhs: FavoriteFetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.success(lhs), .success(rhs)):
            return lhs == rhs
        case let (.failed(lhs), .failed(rhs)):
            return lhs.localizedDescription == rhs.localizedDescription
        default: return false
        }
    }
}

enum FavoriteRouteAction {
    case idleRoute
    case navigateToMainTab
}
 
enum FavoriteViewModelAction {
    case navigateToMainTab
}



