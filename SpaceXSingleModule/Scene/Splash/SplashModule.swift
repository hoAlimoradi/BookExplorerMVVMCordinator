//
//  SplashModule.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//

import Foundation

enum SplashModule {
    struct Configuration { 
    }

    // MARK: - Alias
    typealias SceneView = SplashViewController

    static func build(configuration: Configuration,
                      coordinator: ProjectCoordinatorProtocol) -> SceneView {
        let viewModel = SplashViewModel(configuration: configuration)
        let router = SplashRouter(coordinator: coordinator)
        let viewController = SceneView(configuration: configuration,
                                       viewModel: viewModel,
                                       router: router)
        return viewController
    }
}
