//
//  LifecycleObserver.swift
//  SpaceXSingleModule
//
//  Created by ho on 6/9/1403 AP.
//
/*
import UIKit
import Combine
import Foundation
import UIKit

final class LifecycleObserver<LifecycleEvent: LifecycleEventProtocol> {
    private weak var viewController: UIViewController?
    private var lifecycleEvent: LifecycleEventProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(lifecycleEvent: LifecycleEvent) {
           self.lifecycleEvent = lifecycleEvent
       }
    func observe(viewController: UIViewController) {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak lifecycleEvent] _ in
                lifecycleEvent?.handleLifecycleEvent(.didBecomeActiveView)
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak lifecycleEvent] _ in
                lifecycleEvent?.handleLifecycleEvent(.willResignActiveView)
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak lifecycleEvent] _ in
                lifecycleEvent?.handleLifecycleEvent(.didEnterBackgroundView)
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak lifecycleEvent] _ in
                lifecycleEvent?.handleLifecycleEvent(.willEnterForegroundView)
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak lifecycleEvent] _ in
                lifecycleEvent?.handleLifecycleEvent(.didReceiveMemoryWarning)
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { [weak lifecycleEvent] _ in
                lifecycleEvent?.handleLifecycleEvent(.willTerminateApplication)
            }.store(in: &cancellables)
    }
}
*/
