//
//  BaseViewModel.swift

 
import Foundation
import Combine

// Ensure the protocol is class-constrained
protocol LifecycleEventProtocol {
    func onDidLoadView()
    func onWillAppearView()
    func onDidAppearView()
    func onWillDisappearView()
    func onDidDisappearView()
    func onDidBecomeActiveView()
    func onWillResignActiveView()
    func onDidEnterBackgroundView()
    func onWillEnterForegroundView()
    func onDidReceiveMemoryWarning()
    func onWillTerminateApplication()

    func handleLifecycleEvent(_ event: LifecycleEvent)
}

// Provide default implementations
extension LifecycleEventProtocol {
    func onDidLoadView() {}
    func onWillAppearView() {}
    func onDidAppearView() {}
    func onWillDisappearView() {}
    func onDidDisappearView() {}
    func onDidBecomeActiveView() {}
    func onWillResignActiveView() {}
    func onDidEnterBackgroundView() {}
    func onWillEnterForegroundView() {}
    func onDidReceiveMemoryWarning() {}
    func onWillTerminateApplication() {}
    
    func handleLifecycleEvent(_ event: LifecycleEvent) {
        switch event {
        case .didLoadView:
            onDidLoadView()
        case .willAppearView:
            onWillAppearView()
        case .didAppearView:
            onDidAppearView()
        case .willDisappearView:
            onWillDisappearView()
        case .didDisappearView:
            onDidDisappearView()
        case .didBecomeActiveView:
            onDidBecomeActiveView()
        case .willResignActiveView:
            onWillResignActiveView()
        case .didEnterBackgroundView:
            onDidEnterBackgroundView()
        case .willEnterForegroundView:
            onWillEnterForegroundView()
        case .didReceiveMemoryWarning:
            onDidReceiveMemoryWarning()
        case .willTerminateApplication:
            onWillTerminateApplication()
        }
    }
}



enum LifecycleEvent {
    case didLoadView
    case willAppearView
    case didAppearView
    case willDisappearView
    case didDisappearView
    case didBecomeActiveView
    case willResignActiveView
    case didEnterBackgroundView
    case willEnterForegroundView
    case didReceiveMemoryWarning
    case willTerminateApplication
}

/*
 class BaseViewModel1 {
     // Lifecycle subjects
     private var lifecycleSubject = PassthroughSubject<LifecycleEvent, Never>()
     private var cancellables = Set<AnyCancellable>()
     
     init() {
         bindLifecycleEvents()
     }
     
     private func bindLifecycleEvents() {
         lifecycleSubject
             .sink { [weak self] event in
                 guard let self = self else { return }
                 switch event {
                 case .didLoadView:
                     self.onDidLoadView()
                 case .willAppearView:
                     self.onWillAppearView()
                 case .didAppearView:
                     self.onDidAppearView()
                 case .willDisappearView:
                     self.onWillDisappearView()
                 case .didDisappearView:
                     self.onDidDisappearView()
                 case .didBecomeActiveView:
                     self.onDidBecomeActiveView()
                 case .willResignActiveView:
                     self.onWillResignActiveView()
                 case .didEnterBackgroundView:
                     self.onDidEnterBackgroundView()
                 case .willEnterForegroundView:
                     self.onWillEnterForegroundView()
                 case .didReceiveMemoryWarning:
                     self.onDidReceiveMemoryWarning()
                 case .willTerminateApplication:
                     self.onWillTerminateApplication()
                 }
             }
             .store(in: &cancellables)
     }
     
     func onDidLoadView() {}
     func onWillAppearView() {}
     func onDidAppearView() {}
     func onWillDisappearView() {}
     func onDidDisappearView() {}
     func onDidBecomeActiveView() {}
     func onWillResignActiveView() {}
     func onDidEnterBackgroundView() {}
     func onWillEnterForegroundView() {}
     func onDidReceiveMemoryWarning() {}
     func onWillTerminateApplication() {}
     
     func handleLifecycleEvent(_ event: LifecycleEvent) {
         lifecycleSubject.send(event)
     }
 }
 */


/*
 //MARK: Solution 2: Centralized Lifecycle Handling with a Manager

class LifecycleManager {
    static let shared = LifecycleManager()
    
    private var lifecycleEventSubject = PassthroughSubject<LifecycleEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func observeLifecycleEvents(for viewModel: BaseViewModel) {
        lifecycleEventSubject
            .sink { event in
                viewModel.handleLifecycleEvent(event)
            }
            .store(in: &cancellables)
    }
    
    func notify(event: LifecycleEvent) {
        lifecycleEventSubject.send(event)
    }
}

// BaseViewModel adapted for the manager approach
class BaseViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        LifecycleManager.shared.observeLifecycleEvents(for: self)
    }
    
    func handleLifecycleEvent(_ event: LifecycleEvent) {
        switch event {
        case .viewDidBecomeActive:
            onViewDidBecomeActive()
        case .viewDidEnterBackground:
            onViewDidEnterBackground()
        }
    }
    
    func onViewDidBecomeActive() {
        // Override in subclass if needed
    }
    
    func onViewDidEnterBackground() {
        // Override in subclass if needed
    }
}
 */

