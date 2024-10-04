//
//  AppStrings.swift
 

import Foundation
public enum AppStrings {
    //MARK: General String
    public enum General: String {
        case errorAlertTitle = "general_error_alert_title"
        case cancelTitle = "general_cancel_title"
        case description = "general_description"
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    //MARK: Splash String
    public enum MainTab: String {
        case home = "main_tab_home_title"
        case favorite = "main_tab_favorite_title"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    //MARK: Splash String
    public enum Splash: String {
        case title = "splash_title"
        case vertion = "splash_vertion"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    //MARK: Search String
    public enum Search: String {
        case title = "search_next"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    //MARK: Home String
    public enum Home: String {
        case title = "home_title"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    //MARK: Details String
    public enum Details: String {
        case title = "details_title"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    //MARK: Favorite String
    public enum Favorite: String {
        case title = "favorite_title"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
