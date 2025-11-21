//
//  Font_Extension.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UIFont {
    
    enum Font: String {
        
        case AlexandriaBlack                =  "Alexandria-Black"
        case AlexandriaBold                 =  "Alexandria-Bold"
        case AlexandriaExtraBold            =  "Alexandria-ExtraBold"
        case AlexandriaExtraLight           =  "Alexandria-ExtraLight"
        case AlexandriaLight                =  "Alexandria-Light"
        case AlexandriaMedium               =  "Alexandria-Medium"
        case AlexandriaRegular              =  "Alexandria-Regular"
        case AlexandriaSemiBold             =  "Alexandria-SemiBold"
        case AlexandriaThin                 =  "Alexandria-Thin"
        
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
    
    func appFont() -> UIFont?  {
        var fontName = ""
        
        switch weight {
        case .ultraLight, .thin, .light:
            fontName = Font.AlexandriaLight.name
        case .semibold:
            fontName = Font.AlexandriaSemiBold.name
        case .medium:
            fontName = Font.AlexandriaMedium.name
        case .bold:
            fontName = Font.AlexandriaBold.name
        case .black:
            fontName = Font.AlexandriaBlack.name
        case .heavy:
            fontName = Font.AlexandriaExtraBold.name
        default:
            fontName = Font.AlexandriaRegular.name
        }
        return UIFont.init(name: fontName, size: self.pointSize)
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
