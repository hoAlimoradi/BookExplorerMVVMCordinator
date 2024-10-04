//
//  ThemeManager.swift
//  
 

import Foundation
import UIKit
import Combine 

/// Defines the available themes.
enum Theme: String {
    case light, dark
}

/// Manages the application's themes.
public class ThemeManager {
    
    private enum Constants {
        static var currentThemeKey = "CurrentThemeKey"
    }
    /// UserDefaultsProtocol instance to store theme data.
    private let userDefaultsAPI: UserDefaultsProtocol

    private init(userDefaultsAPI: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaultsAPI = userDefaultsAPI

        // Load the saved theme from UserDefaults
        if let savedTheme = userDefaultsAPI.value(forKey: Constants.currentThemeKey) as? String,
           let theme = Theme(rawValue: savedTheme) {
            currentTheme = theme
        }
    }
    /// Singleton instance of ThemeManager.
    static public let shared = ThemeManager()
     
    /// The current theme.
    private(set) var currentTheme: Theme = .light {
        didSet {
            // Save the current theme to UserDefaults via UserDefaultsProtocol
            userDefaultsAPI.setValue(currentTheme.rawValue, forKey: Constants.currentThemeKey)
            // Notify subscribers about the theme change
            themeSubject.send(currentTheme)
        }
    }

    /// Publisher for theme changes.
    var themePublisher: AnyPublisher<Theme, Never> {
        themeSubject.eraseToAnyPublisher()
    }

    private var themeSubject = PassthroughSubject<Theme, Never>()

    /// Applies a theme.
    /// - Parameter theme: The theme to be applied.
    func applyTheme(_ theme: Theme) {
        currentTheme = theme

        let themeColors: ColorTheme = theme == .light ? LightTheme() : DarkTheme()

        // Customize your UI
        UINavigationBar.appearance().backgroundColor = themeColors.primary1
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeColors.primary2]

        // Notify subscribers about the theme change
        themeSubject.send(currentTheme)
    }

    /// Gets the colors of the current theme.
    /// - Returns: The colors of the current theme.
    func getCurrentThemeColors() -> ColorTheme {
        return currentTheme == .light ? LightTheme() : DarkTheme()
    }
}
