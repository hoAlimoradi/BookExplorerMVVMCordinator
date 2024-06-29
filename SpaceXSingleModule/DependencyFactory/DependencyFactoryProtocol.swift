//
//  DependencyFactoryProtocol.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation

/// Protocol defining the methods for building view controllers within the application.
///
/// `DependencyFactoryProtocol` outlines the construction of various view controllers,
/// each associated with a specific part of the app, while passing the necessary coordinator
/// for navigation and coordination purposes.
protocol DependencyFactoryProtocol {
    
    /// Builds the main tab bar controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `CustomTabBarController` instance configured with the given coordinator.
    func buildMainTab(_ coordinator: ProjectCoordinatorProtocol) -> CustomTabBarController
    
    /// Builds the splash view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `SplashViewController` instance configured with the given coordinator.
    func buildSplash(_ coordinator: ProjectCoordinatorProtocol) -> SplashViewController
    
    /// Builds the home view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `HomeViewController` instance configured with the given coordinator.
    func buildHome(_ coordinator: ProjectCoordinatorProtocol) -> HomeViewController
    
    /// Builds the favorite view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `FavoriteViewController` instance configured with the given coordinator.
    func buildFavorite(_ coordinator: ProjectCoordinatorProtocol) -> FavoriteViewController
    
    /// Builds the details view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `DetailsViewController` instance configured with the given coordinator.
    func buildDetails(_ coordinator: ProjectCoordinatorProtocol) -> DetailsViewController
}
