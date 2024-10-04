//
//  CustomTabBarController.swift

 
import Foundation
import UIKit 
import Combine

final class MainTabBarController: UITabBarController  {
    
    private enum Constans {
        static var smallerSolidWhiteCircle = "\u{2022}"
        static var selectedIconHome = "ic_community_selected"
        static var unselectedIconHome = "ic_community_unselected"
        static var selectedIconFavoriteTabBar = "ic_notification_selected_tab_bar"
        static var unselectedIconFavoriteTabBar = "ic_notification_selected_tab_bar_unselected"
        static var curvedTabBarKey = "tabBar"
    }

    private let coordinator: ProjectCoordinatorProtocol
    private let factory: DependencyFactory

    private var homeViewController: HomeViewController
    private var favoriteViewController: FavoriteViewController
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: --- homeTabBarItem
    // Set custom images for the selected and unselected states
    private lazy var selectedIconHome = UIImage(named: Constans.selectedIconHome)?.withRenderingMode(.alwaysOriginal)
    
    private lazy var unselectedIconHome = UIImage(named: Constans.unselectedIconHome)?.withRenderingMode(.alwaysOriginal)
    
    // Set the tab bar item with custom icons for selected and unselected states
    private lazy var tabBarItemHome = UITabBarItem(title: AppStrings.MainTab.home.localized,
                                                  image: unselectedIconHome,
                                                  selectedImage: selectedIconHome)
 
    //MARK: favoriteTabBarItem
    // Set custom images for the selected and unselected states
    private lazy var selectedIconFavoriteTabBar = UIImage(named: Constans.selectedIconFavoriteTabBar)?.withRenderingMode(.alwaysOriginal)
    private lazy var unselectedIconFavoriteTabBar = UIImage(named: Constans.unselectedIconFavoriteTabBar)?.withRenderingMode(.alwaysOriginal)
    
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
        setValue(CurvedTabBar(frame: tabBar.frame), forKey: Constans.curvedTabBarKey)
  
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
        updateTabbarIndex(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.getCurrentThemeColors().white2]
    }
     
}
 
//MARK: tabBar
extension MainTabBarController {
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
extension MainTabBarController: TabBarControllerProtocol {
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
extension MainTabBarController {
 
    private func observeNotificationCountPublisher() {
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

