//
//  CustomTabBarController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
 
import Foundation
import UIKit 
import Combine

final class CustomTabBarController: UITabBarController  {
    
    private enum Constans {
        static var smallerSolidWhiteCircle = "\u{2022}"
    }

    private let coordinator: ProjectCoordinatorProtocol
    private let factory: DependencyFactory

    private var homeViewController: HomeViewController
    private var favoriteViewController: FavoriteViewController
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: --- homeTabBarItem
    // Set custom images for the selected and unselected states
    private lazy var selectedIconHome = UIImage(named: "ic_community_selected")?.withRenderingMode(.alwaysOriginal)
    
    private lazy var unselectedIconHome = UIImage(named: "ic_community_unselected")?.withRenderingMode(.alwaysOriginal)
    
    // Set the tab bar item with custom icons for selected and unselected states
    private lazy var tabBarItemHome = UITabBarItem(title: AppStrings.MainTab.home.localized,
                                                  image: unselectedIconHome,
                                                  selectedImage: selectedIconHome)
    
    
    //MARK: favoriteTabBarItem
    // Set custom images for the selected and unselected states
    private lazy var selectedIconFavoriteTabBar = UIImage(named: "ic_notification_selected_tab_bar")?.withRenderingMode(.alwaysOriginal)
    private lazy var unselectedIconFavoriteTabBar = UIImage(named: "ic_notification_selected_tab_bar_unselected")?.withRenderingMode(.alwaysOriginal)
    
    // Set the tab bar item with custom icons for selected and unselected states
    private lazy var favoriteTabBarItem = UITabBarItem(title: AppStrings.MainTab.favorite.localized,
                                                       image: unselectedIconFavoriteTabBar,
                                                       selectedImage: selectedIconFavoriteTabBar)
    
    init(coordinator: ProjectCoordinatorProtocol,
         factory: DependencyFactory) {
        self.coordinator = coordinator
        self.factory = factory
        self.homeViewController = factory.buildHome(coordinator)
        self.favoriteViewController = factory.buildFavorite(coordinator)
        
        super.init(nibName: nil, bundle: nil)
        self.setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func setupViewControllers() {
        setValue(CurvedTabBar(frame: tabBar.frame), forKey: "tabBar")
  
        // MARK: --- Home
        let HomeVC = CustomNavigationController(rootViewController: homeViewController)

        // Customize the title text attributes for both selected and normal states
        let selectedAttributesHome: [NSAttributedString.Key: Any] = [
            .font: Fonts.B3.semiBold,
            .foregroundColor: ThemeManager.shared.getCurrentThemeColors().primary1
        ]
        let deselctedAttributesHome: [NSAttributedString.Key: Any] = [
            .font: Fonts.B3.semiBold,
            .foregroundColor: ThemeManager.shared.getCurrentThemeColors().grey1
        ]
        tabBarItemHome.setTitleTextAttributes(selectedAttributesHome, for: .selected)
        tabBarItemHome.setTitleTextAttributes(deselctedAttributesHome, for: .normal)
        HomeVC.tabBarItem = tabBarItemHome
 
        // MARK: --- Favorite
        let favoriteVC = CustomNavigationController(rootViewController: favoriteViewController)
        
        // Customize the title text attributes for both selected and normal states
        let selectedAttributesFavorite: [NSAttributedString.Key: Any] = [
            .font: Fonts.B3.semiBold,
            .foregroundColor: ThemeManager.shared.getCurrentThemeColors().primary1
        ]
        
        let deselctedAttributesFavorite: [NSAttributedString.Key: Any] = [
            .font: Fonts.B3.semiBold,
            .foregroundColor:ThemeManager.shared.getCurrentThemeColors().grey1
        ]
        favoriteTabBarItem.setTitleTextAttributes(selectedAttributesFavorite, for: .selected)
        favoriteTabBarItem.setTitleTextAttributes(deselctedAttributesFavorite, for: .normal)
        favoriteVC.tabBarItem = favoriteTabBarItem
 
        viewControllers = [HomeVC, favoriteVC]
 
        observeFavoritePublisher()
        
        observeFavoritePublisher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.getCurrentThemeColors().white2]
    }
     
}
 
//MARK: tabBar
extension CustomTabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let items = tabBar.items,
            let index = items.firstIndex(of: item)
        else {
            return
        }
        updateTabbarIndex(index: index)
    }
    
    func updateTabbarIndex(index: Int) {
        (self.tabBar as? CustomTabBar)?.didSelectTap.send(index)
        selectedIndex = index
        
        updateCoordinatorRoot(index)
    }
    
    func updateCoordinatorRoot(_ index: Int) {
        switch index {
        case 0:
            self.coordinator.updateCoordinatorRoot(homeViewController)
        case 1:
            self.coordinator.updateCoordinatorRoot(favoriteViewController)
        default:
            break
        }
    }
}
//MARK: TabBarControllerProtocol
extension CustomTabBarController: TabBarControllerProtocol {
    func getHomeViewController() -> HomeViewController {
        homeViewController
    }
    
    func getFavoriteViewController() -> FavoriteViewController {
        favoriteViewController
    }
    func showHome() {
        updateTabbarIndex(index: TabBarViewIndex.home.rawValue)
    }
    func showFavorite() {
        updateTabbarIndex(index: TabBarViewIndex.favorite.rawValue)
    }
}
 
//MARK: update NotificationManager Badge Count
extension CustomTabBarController {
 
    private func observeNotificationCountPublisher() {
        favoriteViewController.notificationCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] unreadCount in
                guard let self = self,
                      let unreadCount = unreadCount else { return }
                self.updateFavoriteBadgeCount(unreadCount)
            }.store(in: &cancellables)
    }

    private func observeFavoritePublisher() {
        GeneralSenarioManager.shared.recentlyFavoriteCountModelItemSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalUnreadCount in
                self?.updateFavoriteBadgeCount(totalUnreadCount)
            }
            .store(in: &cancellables)
    }

  
    func updateFavoriteBadgeCount(_ count: Int) {
        if count > 0 {
            favoriteTabBarItem.badgeValue = Constans.smallerSolidWhiteCircle
        } else {
            favoriteTabBarItem.badgeValue = nil
        }
    }
}
class CurvedTabBar: CustomTabBar {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        roundCorners(corners: [.topLeft, .topRight],
                     radius: 20,
                     bgColor: ThemeManager.shared.getCurrentThemeColors().white2,
                     cornerCurve: .continuous,
                     shadowColor: ThemeManager.shared.getCurrentThemeColors().grey1,
                     shadowOffset: CGSize(width: 0, height: 1),
                     shadowOpacity: 0.0, shadowRadius: 0, boundsInset: UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0))
    }
}

//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//    }
/*
 override func draw(_ rect: CGRect) {
 super.draw(rect)
 roundCorners(corners: [.topLeft, .topRight], radius: 20, bgColor: .white, cornerCurve: .circular, shadowColor: .black, shadowOffset: CGSize(width: 0, height: -2), shadowOpacity: 0.1, shadowRadius: 4, boundsInset: UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0))
 }
 */

