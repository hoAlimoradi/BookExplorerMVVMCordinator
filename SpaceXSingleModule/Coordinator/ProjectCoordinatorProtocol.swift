//
//  ProjectCoordinatorProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//

import UIKit
import Combine

/// A protocol that defines the required methods and properties for a project coordinator.
///
/// `ProjectCoordinatorProtocol` manages the navigation flow and provides methods to
/// initialize and navigate between different view controllers in the application.
protocol ProjectCoordinatorProtocol {

    // MARK: - Initialization and Root Navigation
    /// The current root view controller managed by the coordinator.
    var viewController: UIViewController? { get set }
    
    /// A subject that triggers navigation to a chat based on the provided channel URL.
    var showChatBasedOnChannelURLSubject: PassthroughSubject<String?, Never> { get set }
    
    /// A subject that triggers navigation based on the provided link type.
    var linkTypeSubject: PassthroughSubject<String?, Never> { get set }
    
    /// Creates and returns the splash view controller.
    ///
    /// - Returns: An instance of `SplashViewController`.
    func makeSplashViewController() -> SplashViewController
    
    /// Starts the coordinator with the provided root view controller.
    ///
    /// - Parameter viewController: The root view controller to start the coordinator with.
    func start(_ viewController: UIViewController)
    
    /// Updates the root view controller of the coordinator.
    ///
    /// - Parameter viewController: The new root view controller.
    func updateCoordinatorRoot(_ viewController: UIViewController)
    
    /// Pops the top view controller from the navigation stack.
    func popUp()
    
    // MARK: - MainTab
    /// Navigates to the main tab view controller.
    func navigateToMainTab()
    
    // MARK: - Details    
    /// Navigates to the details view controller for the specified ID.
    ///
    /// - Parameter id: The ID of the item to display in the details view controller.
    func navigateToDetails(by id: String)
}

