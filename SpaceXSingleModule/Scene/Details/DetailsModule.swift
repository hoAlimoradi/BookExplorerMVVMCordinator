//
//  DetailsModule.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
import Foundation

enum DetailsModule {
    struct Configuration {
        let launchAPI: LaunchAPIProtocol
    }

    // MARK: - Alias
    typealias SceneView = DetailsViewController

    static func build(configuration: Configuration,
                      coordinator: ProjectCoordinatorProtocol) -> SceneView {
        let viewModel = DetailsViewModel(configuration: configuration)
        let router = DetailsRouter(coordinator: coordinator)
        let viewController = SceneView(configuration: configuration,
                                       viewModel: viewModel,
                                       router: router)
        return viewController
    }
}
