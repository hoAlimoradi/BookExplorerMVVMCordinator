//
//  extension+UINavigationController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation
import UIKit

extension UINavigationController {

    /// Pushes a view controller onto the receiver’s stack and updates the display only if the last view controller is not of the same type.
    func pushViewControllerOnce(_ viewController: UIViewController, animated: Bool) {
        // Check if the top view controller is of the same type as the one trying to be pushed
        if let topVC = self.viewControllers.last, type(of: topVC) == type(of: viewController) {
            return
        }
        // If not, push the view controller
        self.pushViewController(viewController, animated: animated)
    }

}

