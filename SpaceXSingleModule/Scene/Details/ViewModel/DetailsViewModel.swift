//
//  DetailsViewModel.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Combine
import Foundation
import UIKit

final class DetailsViewModel: DetailsViewModelProtocol {

    private enum Constants {
    }
     
    // MARK: - Properties
    var route = CurrentValueSubject<DetailsRouteAction, Never>(.idleRoute)
    var favoriteStatusSubject = CurrentValueSubject<FavoriteStatusEnum?, Never>(nil)
    var imageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var launchDetailsItemModelSubject = CurrentValueSubject<LaunchDetailsItemModel?, Never>(nil)
    
    private let launchAPI: LaunchAPIProtocol
    private var isFavorite: Bool
    private let launchItemModel: LaunchItemModel
    private let launchDetailsItemModel: LaunchDetailsItemModel
    
    // MARK: - Initialize
    init(configuration: DetailsModule.Configuration) {
        launchAPI = configuration.launchAPI
        isFavorite = configuration.isFavorite
        launchItemModel = configuration.launchItemModel
        launchDetailsItemModel = configuration.launchItemModel.toLaunchDetailsItemModel()
        setPublisher()
    }

    func action(_ handler: DetailsViewModelAction) {
        switch handler {
        case .toggleButton:
            toggleButton()
        case .checkIsFavorite:
            checkIsFavorite()
        case .toggleItem(let item):
            toggleItem(item)
        case .export:
            export()
        }
    }
    private func export() {
        route.send(.shareExport(launchItemModel.toKeyValueItems().toKeyValueString()))
        
    }
    private func setPublisher() {
        launchDetailsItemModelSubject.send(launchDetailsItemModel) 
    }
    private func toggleItem(_ item: String?) {
        guard let item = item, let _ = item.asURL() else {
            return
        }
        route.send(.openUrl(item))
    }
    //MARK:  toggleButton
    private func toggleButton() {
        isFavorite.toggle()
        if isFavorite {
            saveFavoriteLaunchItem()
            favoriteStatusSubject.send(.favorite)
        } else {
            deleteFavoriteLaunchItem()
            favoriteStatusSubject.send(.notFavorite)
        }
    }
    
    //MARK:  checkIsFavorite
    private func checkIsFavorite() {
        if isFavorite {
            favoriteStatusSubject.send(.favorite)
        } else {
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    let result = try await self.launchAPI.isLaunchItemExist(with: launchItemModel.id)
                    if result {
                        favoriteStatusSubject.send(.favorite)
                    } else {
                        favoriteStatusSubject.send(.notFavorite)
                    }
                } catch {
                    LoggingAPI.shared.log("checkIsFavorite \(error.customLocalizedDescription)", level: .error)
                }
            }
        }
    }
    
     
    private func saveFavoriteLaunchItem() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.launchAPI.saveFavoriteLaunchItem(launchItemModel)
            } catch {
                LoggingAPI.shared.log("saveFavoriteLaunchItem \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
    
    private func deleteFavoriteLaunchItem() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.launchAPI.deleteFavoriteLaunchItem(by: launchItemModel.id) 
            } catch {
                LoggingAPI.shared.log("deleteFavoriteLaunchItem \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
}
