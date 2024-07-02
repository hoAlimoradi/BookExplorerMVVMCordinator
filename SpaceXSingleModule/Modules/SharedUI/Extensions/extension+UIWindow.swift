//
//  extension+UIWindow.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import UIKit

/// Extends `UIWindow` to provide a method for smoothly transitioning to a new root view controller.
extension UIWindow {
    
    /// Switches the root view controller of the window with optional animation.
    /// - Parameters:
    ///   - viewController: The new root view controller to set.
    ///   - animated: Whether to animate the transition. Defaults to `true`.
    ///   - duration: The duration of the transition animation. Defaults to `0.1` seconds.
    ///   - options: The animation options. Defaults to cross dissolve transition (`UIView.AnimationOptions.transitionCrossDissolve`).
    ///   - completion: A closure to be executed after the transition animation completes. Defaults to `nil`.
    func switchRootViewController(_ viewController: UIViewController, animated: Bool = true, duration: TimeInterval = 0.1, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }

        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}

