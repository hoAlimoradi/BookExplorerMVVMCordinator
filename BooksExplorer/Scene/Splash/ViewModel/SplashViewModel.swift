//
//  SplashViewModel.swift
//  
//
//  Created by ho on 4/8/1403 AP.
//

import Combine
import Foundation 

final class SplashViewModel: SplashViewModelProtocol {

    private enum Constants {
        static let delay = 0.5
    }

    // MARK: - Properties
    var route = CurrentValueSubject<SplashRouteAction, Never>(.idleRoute) 
  
    // MARK: - Initialize
    init(configuration: SplashModule.Configuration) {
    }

    func action(_ handler: SplashViewModelAction) {
        switch handler {
        case .observeLifecycle(let lifecycleObserver):
            observeLifecycle(with: lifecycleObserver)
        }
    }
    
    // MARK: - Private Methods
    /// Observes lifecycle events and performs specific actions based on the event type.
    /// - Parameter lifecycleEvent: The lifecycle event being observed. Different lifecycle events trigger different actions.
    private func observeLifecycle(with lifecycleEvent: LifecycleEvent) {
        switch lifecycleEvent {
        case .didLoadView:
            navigateToMainTab()
        case .willAppearView,
                .didAppearView,
                .willDisappearView,
                .didDisappearView,
                .didBecomeActiveView,
                .willResignActiveView,
                .didEnterBackgroundView,
                .willEnterForegroundView,
                .didReceiveMemoryWarning,
                .willTerminateApplication:
            break
        }
    }
    //MARK:  navigateToMainTab
    private func navigateToMainTab() { 
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delay) {[weak self] in
            guard let self = self else {return}
            self.route.send(.navigateToMainTab)
        }
    }
}

