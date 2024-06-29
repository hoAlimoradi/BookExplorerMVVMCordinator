//
//  SplashViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation
import Combine

protocol SplashViewModelProtocol {
    func action(_ handler: SplashViewModelAction)
}

enum SplashFetchState: Equatable {
    case idle
    case loading
    case success(String?)
    case failed(Error)

    static func == (lhs: SplashFetchState, rhs: SplashFetchState) -> Bool {
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

enum SplashRouteAction {
    case idleRoute 
    case navigateToMainTab
}
 
enum SplashViewModelAction {
    case navigateToMainTab
}


