//
//  DetailsModule.swift
//  

import Foundation

enum DetailsModule {
    struct Configuration {
        let searchBookAPI: SearchBookAPIProtocol
        let selectBookItemModel: BookItemModel
        let isFavorite: Bool
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
