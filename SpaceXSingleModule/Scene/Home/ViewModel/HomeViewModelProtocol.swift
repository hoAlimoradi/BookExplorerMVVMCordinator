//
//  HomeViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation
import Combine

protocol HomeViewModelProtocol {
    func action(_ handler: HomeViewModelAction)
}

enum HomeFetchState: Equatable {
    case idle
    case loading
    case success(String?)
    case failed(Error)

    static func == (lhs: HomeFetchState, rhs: HomeFetchState) -> Bool {
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

enum HomeRouteAction {
    case idleRoute
    case navigateToMainTab
}
 
enum HomeViewModelAction {
    case navigateToMainTab
}



