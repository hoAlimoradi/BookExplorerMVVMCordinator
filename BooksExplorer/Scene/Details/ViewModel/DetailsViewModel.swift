//
//  DetailsViewModel.swift
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
    var bookKeyValueItemModelsSubject = CurrentValueSubject<[BookKeyValueItemModel]?, Never>(nil)
   
    private let searchBookAPI: SearchBookAPIProtocol
    private var isFavorite: Bool
    private let bookItemModel: BookItemModel
    
    // MARK: - Initialize
    init(configuration: DetailsModule.Configuration) {
        searchBookAPI = configuration.searchBookAPI
        isFavorite = configuration.isFavorite
        bookItemModel = configuration.selectBookItemModel
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
        case .observeLifecycle(let lifecycleObserver):
            observeLifecycle(with: lifecycleObserver)
        }
    }
    
    // MARK: - Private Methods
    /// Observes lifecycle events and performs specific actions based on the event type.
    /// - Parameter lifecycleEvent: The lifecycle event being observed. Different lifecycle events trigger different actions.
    private func observeLifecycle(with lifecycleEvent: LifecycleEvent) {
        switch lifecycleEvent {
        case .didLoadView:
            checkIsFavorite()
        case .willAppearView,
                .didAppearView,
                .willDisappearView,
                .didDisappearView,
                .didBecomeActiveView,
                .willResignActiveView,
                .didEnterBackgroundView,
                .willEnterForegroundView,
                .didReceiveMemoryWarning,
                .willTerminateApplication:
            break
        }
    }
    private func export() {
        route.send(.shareExport(bookItemModel.exportString))
    }
    private func setPublisher() {
        let keyValueItems = bookItemModel()
        bookKeyValueItemModelsSubject.send(keyValueItems)
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
                    let result = try await self.searchBookAPI.isBookItemExist(with: bookItemModel.id)
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
                try await self.searchBookAPI.saveFavoriteBookItem(bookItemModel)
            } catch {
                LoggingAPI.shared.log("saveFavoriteBookItem \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
    
    private func deleteFavoriteLaunchItem() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.searchBookAPI.deleteFavoriteBookItem(by: bookItemModel.id)
            } catch {
                LoggingAPI.shared.log("deleteFavoriteBookItem \(error.customLocalizedDescription)", level: .error)
            }
        }
    }
}
