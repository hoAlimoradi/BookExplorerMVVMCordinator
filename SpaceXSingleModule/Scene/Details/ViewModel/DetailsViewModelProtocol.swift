//
//  DetailsViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation
import Combine

protocol DetailsViewModelProtocol {
    func action(_ handler: DetailsViewModelAction)
}

enum DetailsFetchState: Equatable {
    case idle
    case loading
    case success(String?)
    case failed(Error)

    static func == (lhs: DetailsFetchState, rhs: DetailsFetchState) -> Bool {
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

enum DetailsRouteAction {
    case idleRoute
    case popUp
}
 
enum DetailsViewModelAction {
    case toggleButton
    case checkIsFavorite
}

enum FavoriteStatusEnum {
    case favorite
    case notFavorite
}
