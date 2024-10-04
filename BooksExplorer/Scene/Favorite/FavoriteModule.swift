//
//  FavoriteModule.swift
//  

import Foundation

enum FavoriteModule {
    struct Configuration {
        let searchBookAPI: SearchBookAPIProtocol
    }

    // MARK: - Alias
    typealias SceneView = FavoriteViewController

    static func build(configuration: Configuration,
                      coordinator: ProjectCoordinatorProtocol) -> SceneView {
        let viewModel = FavoriteViewModel(configuration: configuration)
        let router = FavoriteRouter(coordinator: coordinator)
        let viewController = SceneView(configuration: configuration,
                                       viewModel: viewModel,
                                       router: router)
        return viewController
    }
}
