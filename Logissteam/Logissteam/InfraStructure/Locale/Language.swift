//
//  Language.swift
//  Maintenance
//
//  Created by Ahmed abu elregal on 02/12/2023.
//

import UIKit

let APPLE_LANGUAGE_KEY = "AppleLanguages"

class Language: NSObject {
    
    class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        var currentWithoutLocale = "Base"
        if let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as? [String] {
            if var current = langArray.first {
                if let range = current.range(of: "-") {
                    current = String(current[..<range.lowerBound])
                }
                
                currentWithoutLocale = current
            }
        }
        return currentWithoutLocale
    }

    static var currentLanguage: AppLanguage {
        if let lang = AppLanguage(languageIdentifier: currentAppleLanguage()) {
            return lang
        }
        return .english
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,Language.currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }

    static func setCurrentLanguage(_ lang: AppLanguage) {
        let identfier = lang.languageIdentifier
        setAppleLAnguageTo(lang: identfier)
    }
    
    class var isArabic: Bool {
        return Language.currentLanguage == .arabic
    }
    
    class var isEnglish: Bool {
        return Language.currentLanguage == .english
    }
    
    class var isRTL: Bool {
        return Language.isArabic
    }
}

extension Bundle {
    private static let swizzleLocalizationOnce: Void = {
        let originalSelector = #selector(Bundle.localizedString(forKey:value:table:))
        let swizzledSelector = #selector(Bundle.swizzledLocalizedString(forKey:value:table:))
        swizzleMethod(for: Bundle.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    static func swizzleLocalization() {
        _ = swizzleLocalizationOnce
    }
    
    @objc func swizzledLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = Bundle.main.path(forResource: Language.currentLanguage.languageIdentifier, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return swizzledLocalizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.swizzledLocalizedString(forKey: key, value: value, table: tableName)
    }
    
    private static func swizzleMethod(for cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
              let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
            return
        }
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
