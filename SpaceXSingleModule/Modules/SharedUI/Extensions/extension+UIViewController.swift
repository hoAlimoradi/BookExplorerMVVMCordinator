//
//  extension+UIViewController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import UIKit

extension UIViewController {

    func resetToDefaultNavigationItem() {
        // Remove custom left bar button item
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        // Reset back button title
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = nil
        // Reset tint color or any other customization to the navigation bar if required
        self.navigationController?.navigationBar.tintColor = nil
    }
}
