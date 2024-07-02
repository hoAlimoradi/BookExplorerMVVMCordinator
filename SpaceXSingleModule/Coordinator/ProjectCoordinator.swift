//
//  ProjectCoordinator.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation
import UIKit
import Combine

class ProjectCoordinator: AbstractCoordinator,
                          ProjectCoordinatorProtocol {
     
    var showChatBasedOnChannelURLSubject = PassthroughSubject<String?, Never>()
    var linkTypeSubject = PassthroughSubject<String?, Never>()
    
    var childCoordinators: [AbstractCoordinator] = []
    
    weak var viewController: UIViewController?
    
    private let factory: DependencyFactoryProtocol
    
    init(factory: DependencyFactoryProtocol) {
        self.factory = factory
    }
    // Add this private method to log the class name
    private func logViewControllerClassName() {
        if let viewController = viewController {
            LoggingAPI.shared.log("Current base navigator class name: \(viewController.customClassName)", level: .info)
            print()
        } else {
            LoggingAPI.shared.log("Current base navigator is nil", level: .info)
            print()
        }
    }
    
    func addChildCoordinator(_ coordinator: AbstractCoordinator) {
        logViewControllerClassName()
        childCoordinators.append(coordinator)
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        logViewControllerClassName()
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    func removeAllChildCoordinators() {
        logViewControllerClassName()
        childCoordinators.removeAll()
    }
 
    
    /// Start the coordinator, initializing dependencies
    func start(_ viewController: UIViewController) {
        logViewControllerClassName()
        self.viewController = viewController
        logViewControllerClassName() // Log again after setting viewController
    }
 
    func updateCoordinatorRoot(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func popUp() {
        logViewControllerClassName()
        viewController?.resetToDefaultNavigationItem()
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    //MARK: MainTab
    func navigateToMainTab() {
        logViewControllerClassName()
        let vc = factory.buildMainTab(self)
        if let window = UIApplication.shared.windows.first {
            window.switchRootViewController(vc)
        }
    }
    func navigateToDetails(by launchItemModel: LaunchItemModel,
                             isFavorite: Bool) {
        logViewControllerClassName()
        let vc = factory.buildDetails(coordinator: self,
                                      launchItemModel: launchItemModel,
                                      isFavorite: isFavorite)
        viewController?.navigationController?.pushViewControllerOnce(vc, animated: true)
    } 
    
    func openUrl(_ urlString: String?) {
        if let url = urlString, let validUrl = url.asURL() {
            UIApplication.shared.open(validUrl)
        }
    }
}

