//
//  HomeModule.swift
//  

import Foundation

enum HomeModule {
    struct Configuration {
        let searchBookAPI: SearchBookAPIProtocol
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
