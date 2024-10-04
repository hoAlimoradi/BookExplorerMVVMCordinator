//
//  AbstractCoordinator.swift
//  

import UIKit

protocol AbstractCoordinator: AnyObject {
    var childCoordinators: [AbstractCoordinator] { get set }
    func addChildCoordinator(_ coordinator: AbstractCoordinator)
    func removeAllChildCoordinatorsWith<T>(type: T.Type)
    func removeAllChildCoordinators()

    // Updated to take a UIViewController instead of a UINavigationController
    func start(_ viewController: UIViewController)
}
