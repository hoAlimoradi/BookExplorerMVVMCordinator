//
//  DependencyFactory.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
 
import Foundation

/// A factory class responsible for creating and configuring view controllers within the application.
///
/// `DependencyFactory` implements the `DependencyFactoryProtocol` and provides concrete implementations
/// for building various view controllers. It also manages dependencies such as `LauncheAPI`.
class DependencyFactory: DependencyFactoryProtocol {
    
    /// Lazy initialization of `LauncheAPI` conforming to `LauncheAPIProtocol`.
    private lazy var launchAPI: LaunchAPIProtocol = LaunchAPI()
    
    /// Creates and returns the initial project coordinator.
    ///
    /// - Returns: An instance of `ProjectCoordinatorProtocol` initialized with the factory.
    func makeInitialCoordinator() -> ProjectCoordinatorProtocol {
        let coordinator = ProjectCoordinator(factory: self)
        return coordinator
    }
}

// MARK: - Splash
extension DependencyFactory {
    
    /// Builds the splash view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `SplashViewController` instance configured with the given coordinator.
    func buildSplash(_ coordinator: ProjectCoordinatorProtocol) -> SplashViewController {
        let config = SplashModule.Configuration()
        let splashViewController = SplashModule.build(configuration: config,
                                                      coordinator: coordinator)
        return splashViewController
    }
}

// MARK: - MainTab
extension DependencyFactory {
    
    /// Builds the main tab bar controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `CustomTabBarController` instance configured with the given coordinator and factory.
    func buildMainTab(_ coordinator: ProjectCoordinatorProtocol) -> CustomTabBarController {
        let vc = CustomTabBarController(coordinator: coordinator, factory: self)
        return vc
    }
}

// MARK: - Home
extension DependencyFactory {
    
    /// Builds the home view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `HomeViewController` instance configured with the given coordinator and `launcheAPI`.
    func buildHome(_ coordinator: ProjectCoordinatorProtocol) -> HomeViewController {
        let config = HomeModule.Configuration(launchAPI: launchAPI)
        let vc = HomeModule.build(configuration: config, coordinator: coordinator)
        return vc
    }
}

// MARK: - Details
extension DependencyFactory {
    
    /// Builds the details view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `DetailsViewController` instance configured with the given coordinator and `launcheAPI`.
    func buildDetails(coordinator: ProjectCoordinatorProtocol,
                        launchItemModel: LaunchItemModel,
                        isFavorite: Bool) -> DetailsViewController {
        let config = DetailsModule.Configuration(launchAPI: launchAPI,
                                                 launchItemModel: launchItemModel,
                                                 isFavorite: isFavorite)
        let vc = DetailsModule.build(configuration: config, coordinator: coordinator)
        return vc
    }
}

// MARK: - Favorite
extension DependencyFactory {
    
    /// Builds the favorite view controller with the provided coordinator.
    ///
    /// - Parameter coordinator: The coordinator that manages the project navigation.
    /// - Returns: A `FavoriteViewController` instance configured with the given coordinator and `launcheAPI`.
    func buildFavorite(_ coordinator: ProjectCoordinatorProtocol) -> FavoriteViewController {
        let config = FavoriteModule.Configuration(launchAPI: launchAPI)
        let vc = FavoriteModule.build(configuration: config, coordinator: coordinator)
        return vc
    }
}

