//
//  HomeModule.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation

enum HomeModule {
    struct Configuration {
        let launchAPI: LaunchAPIProtocol
    }

    // MARK: - Alias
    typealias SceneView = HomeViewController

    static func build(configuration: Configuration,
                      coordinator: ProjectCoordinatorProtocol) -> SceneView {
        let viewModel = HomeViewModel(configuration: configuration)
        let router = HomeRouter(coordinator: coordinator)
        let viewController = SceneView(configuration: configuration,
                                       viewModel: viewModel,
                                       router: router)
        return viewController
    }
} 
