//
//  HomeViewModelProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation
import Combine

import Foundation
import Combine

// Define HomeViewModelProtocol
protocol HomeViewModelProtocol {
    var route: CurrentValueSubject<HomeRouteAction, Never> { get }
    var launchListSubject: CurrentValueSubject<[LaunchItemModel], Never> { get }
    var homeFetchState: CurrentValueSubject<HomeFetchState, Never> { get }
    
    func action(_ handler: HomeViewModelAction)
}

// Define HomeFetchState enum
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
             (.loadMoreLaunch, .loadMoreLaunch),
             (.emptyLaunch, .emptyLaunch):
            return true
        case let (.failedLaunch(lhsError), .failedLaunch(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// Define HomeRouteAction enum
enum HomeRouteAction {
    case idleRoute
    case navigateToDetails(LaunchItemModel)
}

// Define HomeViewModelAction enum
enum HomeViewModelAction {
    case getLaunchs
    case moreLoadLaunchs
    case selectLaunch(LaunchItemModel)
} 
