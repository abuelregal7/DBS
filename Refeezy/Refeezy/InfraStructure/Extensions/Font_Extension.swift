//
//  Font_Extension.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UIFont {
    
    enum Font: String {
        
        case AvenirLTStdBlack          =  "AvenirLTStd-Black"
        case AvenirLTStdBlackOblique   =  "AvenirLTStd-BlackOblique"
        case AvenirLTStdBook           =  "AvenirLTStd-Book"
        case AvenirLTStdBookOblique    =  "AvenirLTStd-BookOblique"
        case AvenirLTStdHeavyOblique   =  "AvenirLTStd-HeavyOblique"
        case AvenirLTStdLight          =  "AvenirLTStd-Light"
        case AvenirLTStdLightOblique   =  "AvenirLTStd-LightOblique"
        case AvenirLTStdMedium         =  "AvenirLTStd-Medium"
        case AvenirLTStdMediumOblique  =  "AvenirLTStd-MediumOblique"
        case AvenirLTStdOblique        =  "AvenirLTStd-Oblique"
        case AvenirLTStdRoman          =  "AvenirLTStd-Roman"
        
        var name: String {
            return self.rawValue
        }
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    static func appFont(ofSize size: CGFloat, weight: Weight) -> UIFont? {
        return UIFont.systemFont(ofSize: size, weight: weight).appFont()
    }
    
    func appFont() -> UIFont? {
        let fontName: String
        
        switch weight {
        case .ultraLight, .thin, .light:
            fontName = Font.AvenirLTStdLight.name
        case .medium, .semibold:
            fontName = Font.AvenirLTStdMedium.name
        case .bold, .heavy:
            fontName = Font.AvenirLTStdHeavyOblique.name
        case .black:
            fontName = Font.AvenirLTStdBlack.name
        default:
            fontName = Font.AvenirLTStdRoman.name
        }
        
        return UIFont(name: fontName, size: self.pointSize)
    }
    
    var weight: UIFont.Weight {
        
        let fontAttributeKey = UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
        
        guard let fontWeight = self.fontDescriptor.fontAttributes[fontAttributeKey] as? String else {
            return UIFont.Weight.regular
        }
        
        switch fontWeight {
            
        case "CTFontBoldUsage":
            return UIFont.Weight.bold
            
        case "CTFontBlackUsage":
            return UIFont.Weight.black
            
        case "CTFontHeavyUsage":
            return UIFont.Weight.heavy
            
        case "CTFontUltraLightUsage":
            return UIFont.Weight.ultraLight
            
        case "CTFontThinUsage":
            return UIFont.Weight.thin
            
        case "CTFontLightUsage":
            return UIFont.Weight.light
            
        case "CTFontMediumUsage":
            return UIFont.Weight.medium
            
        case "CTFontDemiUsage", "CTFontEmphasizedUsage":
            return UIFont.Weight.semibold
            
        case "CTFontRegularUsage":
            return UIFont.Weight.regular
            
        default:
            return UIFont.Weight.regular
        }
    }
}
