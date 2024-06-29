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
    case idleLaunch
    case loadingLaunch
    case loadMoreLaunch
    case emptyLaunch
    case failedLaunch(Error)

    static func == (lhs: HomeFetchState, rhs: HomeFetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idleLaunch, .idleLaunch),
            (.loadingLaunch, .loadingLaunch),
            (.emptyLaunch, .emptyLaunch):
            return true
        case let (.failedLaunch(lhs), .failedLaunch(rhs)) :
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
    case getLaunchs
    case moreLoadLaunchs
    case selectLaunch(LaunchItemModel)
}



