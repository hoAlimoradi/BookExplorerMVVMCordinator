//
//  FavoriteModule.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation

enum FavoriteModule {
    struct Configuration {
        let launcheAPI: LauncheAPIProtocol
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
