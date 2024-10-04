//
//  ColorTheme.swift
//  
 
import Foundation
import UIKit

/// A protocol that defines the color requirements for a theme.
protocol ColorTheme {
    /// Primary color shades.
    var primary1: UIColor { get }
    var primary2: UIColor { get }
    var primary3: UIColor { get }
    var primary4: UIColor { get }
    
    /// Red color shades.
    var red1: UIColor { get }
    var red2: UIColor { get }
    var red3: UIColor { get }
    
    /// Yellow color shades.
    var yellow1: UIColor { get }
    var yellow2: UIColor { get }
    var yellow3: UIColor { get }
    
    /// Green color shades.
    var green1: UIColor { get }
    var green2: UIColor { get }
    var green3: UIColor { get }
    
    /// White color shades.
    var white1: UIColor { get }
    var white2: UIColor { get }
    var white3: UIColor { get }
    
    /// Black color shades.
    var black1: UIColor { get }
    var black2: UIColor { get }
    var black3: UIColor { get }
    
    /// Grey color shades.
    var grey1: UIColor { get }
    var grey2: UIColor { get }
    var grey3: UIColor { get }
    
    /// Orange color.
    var orange1: UIColor { get }
    
    /// Transparent background colors.
    var transparentBackground: UIColor { get }
    var transparentBackgroundWhite: UIColor { get }
    
    /// Purple color.
    var purple: UIColor { get }
    
    /// Transparent purple background color.
    var purpleTransparentBackground: UIColor { get }
}

/// A light color theme.
struct LightTheme: ColorTheme {
    var primary1 = UIColor(hex: "#2264DC")
    var primary2 = UIColor(hex: "#7694FF")
    var primary3 = UIColor(hex: "#D6D9FF")
    var primary4 = UIColor(hex: "#F2F2FF")
    var red1 = UIColor(hex: "#F03063")
    var red2 = UIColor(hex: "#F06086")
    var red3 = UIColor(hex: "#F090A9")
    var yellow1 = UIColor(hex: "#F3C04B")
    var yellow2 = UIColor(hex: "#F3CF7C")
    var yellow3 = UIColor(hex: "#F3DEAD")
    var green1 = UIColor(hex: "#07CD7B")
    var green2 = UIColor(hex: "#44CD94")
    var green3 = UIColor(hex: "#81CDAE")
    var white1 = UIColor(hex: "#FFFFFF")
    var white2 = UIColor(hex: "#F5F7FA")
    var white3 = UIColor(hex: "#D9DDE5")
    var black1 = UIColor(hex: "#000000")
    var black2 = UIColor(hex: "#1F2229")
    var black3 = UIColor(hex: "#1F2229", alpha: 0.3)
    var grey1 = UIColor(hex: "#868E9C")
    var grey2 = UIColor(hex: "#C0C7D4")
    var grey3 = UIColor(hex: "#C0C7D4", alpha: 0.3)
    var orange1 = UIColor(hex: "#FF7A00")
    var transparentBackground = UIColor.gray.withAlphaComponent(0.9)
    var transparentBackgroundWhite = UIColor.gray.withAlphaComponent(0.3)
    var purple = UIColor(hex: "#8F00FF")
    var purpleTransparentBackground = UIColor(hex: "#8a92ff")
}

/// A dark color theme.
struct DarkTheme: ColorTheme {
    var primary1 = UIColor(hex: "#2264DC")
    var primary2 = UIColor(hex: "#7694FF")
    var primary3 = UIColor(hex: "#D6D9FF")
    var primary4 = UIColor(hex: "#F2F2FF", alpha: 0.6)
    var red1 = UIColor(hex: "#F03063")
    var red2 = UIColor(hex: "#F06086")
    var red3 = UIColor(hex: "#F090A9")
    var yellow1 = UIColor(hex: "#F3C04B")
    var yellow2 = UIColor(hex: "#F3CF7C")
    var yellow3 = UIColor(hex: "#F3DEAD")
    var green1 = UIColor(hex: "#07CD7B")
    var green2 = UIColor(hex: "#44CD94")
    var green3 = UIColor(hex: "#81CDAE")
    var white1 = UIColor(hex: "#FFFFFF")
    var white2 = UIColor(hex: "#F5F7FA")
    var white3 = UIColor(hex: "#D9DDE5")
    var black1 = UIColor(hex: "#000000")
    var black2 = UIColor(hex: "#1F2229")
    var black3 = UIColor(hex: "#1F2229", alpha: 0.3)
    var grey1 = UIColor(hex: "#868E9C")
    var grey2 = UIColor(hex: "#C0C7D4")
    var grey3 = UIColor(hex: "#C0C7D4", alpha: 0.3)
    var orange1 = UIColor(hex: "#FF7A00")
    var transparentBackground = UIColor.gray.withAlphaComponent(0.9)
    var transparentBackgroundWhite = UIColor.gray.withAlphaComponent(0.3)
    var purple = UIColor(hex: "#8F00FF")
    var purpleTransparentBackground = UIColor(hex: "#8a92ff")
}

