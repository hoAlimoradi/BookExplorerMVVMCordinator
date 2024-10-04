//
//  Fonts.swift
 
 
import UIKit
import Foundation

typealias MainFont = Font.HelveticaNeue

enum Font {
    enum HelveticaNeue: String {
        case ultraLightItalic = "UltraLightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case ultraLight = "UltraLight"
        case italic = "Italic"
        case light = "Light"
        case thinItalic = "ThinItalic"
        case lightItalic = "LightItalic"
        case bold = "Bold"
        case thin = "Thin"
        case condensedBlack = "CondensedBlack"
        case condensedBold = "CondensedBold"
        case boldItalic = "BoldItalic"
        
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-\(rawValue)", size: size)!
        }
    }
}
//
extension UIFont.Weight {
    init(_ weight: Int) {
        switch weight {
        case 100: self = .ultraLight
        case 200: self = .thin
        case 300: self = .light
        case 400: self = .regular
        case 500: self = .medium
        case 600: self = .semibold
        case 700: self = .bold
        case 800: self = .heavy
        case 900: self = .black
        default: self = .regular
        }
    }
}

// Usage

let fontWeight400 = UIFont.Weight(400)
let fontWeight500 = UIFont.Weight(500)
let fontWeight600 = UIFont.Weight(600)

enum FontWeight: CGFloat {
    case weight400 = 400
    case weight500 = 500
    case weight600 = 600
    
    var value: UIFont.Weight {
        return UIFont.Weight(rawValue: self.rawValue)
    }
}

struct Fonts {

    private struct FontSize {
        
        static let headingXXSize = CGFloat(60)
        static let headingXSize = CGFloat(44)
        static let headingsSize = CGFloat(24)
        static let titleSize = CGFloat(16)
        static let subtitleSize = CGFloat(14)
        static let smallSubtitleSize = CGFloat(12)
        static let largeBodySize = CGFloat(16)
        static let bodySize = CGFloat(14)
        static let smallBodySize = CGFloat(12)
        static let buttonSize = CGFloat(14)
        static let largeButtonSize = CGFloat(16)
        static let smallButtonSize = CGFloat(12)
        static let captionSize = CGFloat(10)
        static let overlineSize = CGFloat(8)
    }

    private struct FontName {
        static let interThinUIFontName = "Inter-Thin"
        static let interExtraLightUIFontName = "Inter-ExtraLight"
        static let interLightUIFontName = "Inter-Light"
        static let interRegularUIFontName = "Inter-Regular"
        static let interMediumUIFontName = "Inter-Medium"
        static let interSemiBoldUIFontName = "Inter-SemiBold"
        static let interBoldUIFontName = "Inter-Bold"
        static let interExtraBoldUIFontName = "Inter-ExtraBold"
        static let interBlackUIFontName = "Inter-Black"
 
        static let regularSFProUIFontName = "SFProDisplay-Regular"
 
    }
    //MARK: H1
    struct H1 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(32))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(32))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(32))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(32))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(32))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(32))
    }

    //MARK: H2
    struct H2 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(28))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(28))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(28))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(28))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(28))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(28))
    }

    //MARK: H3
    struct H3 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(24))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(24))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(24))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(24))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(24))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(24))
    }

    //MARK: H4
    struct H4 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(20))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(20))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(20))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(20))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(20))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(20))
    }

    //MARK: Body B1
    struct B1 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(16))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(16))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(16))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(16))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(16))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(16))
        
        static let bold = UIFont(name: FontName.interBoldUIFontName, size: CGFloat(16))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(16))
    }

    //MARK: B2
    struct B2 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(14))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(14))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(14))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(14))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(14))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(14))
        
        static let Bold = UIFont(name: FontName.interBoldUIFontName, size: CGFloat(14))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(14))
    }
    
    //MARK: B3
    struct B3 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(12))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(12))
        
        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(12))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(12))
        
        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(12))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(12))
            
        static let Bold = UIFont(name: FontName.interBoldUIFontName, size: CGFloat(12))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(10))

    }

    //MARK: Caption C1
    struct C1 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(10))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(10))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(10))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(10))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(10))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(10))
    }
    
    //MARK: Caption C1Caps
    struct C1Caps {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(10))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(10))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(10))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(10))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(10))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(10))
    }
    
    //MARK: Caption C2
    struct C2 {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(8))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(8))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(8))
    }
    
    //MARK: Caption C2Caps
    struct C2Caps {
        static let regular = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight400.value) ?? UIFont.systemFont(ofSize: CGFloat(8))

        static let medium = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(8))

        static let semiBold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(8))
        
        static let Bold = UIFont(name: FontName.interSemiBoldUIFontName, size: CGFloat(8))?.withWeight(FontWeight.weight600.value) ?? UIFont.systemFont(ofSize: CGFloat(8))
    }
    
    //MARK: Caption C2Caps
    struct OptionsNumber {
        static let small = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(16))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(16))

        static let medium = UIFont(name: FontName.interRegularUIFontName, size: CGFloat(20))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(20))

        static let big = UIFont(name: FontName.interMediumUIFontName, size: CGFloat(24))?.withWeight(FontWeight.weight500.value) ?? UIFont.systemFont(ofSize: CGFloat(24))
    }
}

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: weight]
                                                            ])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}


