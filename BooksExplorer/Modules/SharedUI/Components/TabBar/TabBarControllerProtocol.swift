//
//  TabBarControllerProtocol.swift
//  
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
protocol TabBarControllerProtocol {
    func getHomeViewController() -> HomeViewController
    func getFavoriteViewController() -> FavoriteViewController 
    
    func showHome()
    func showFavorite()
}
