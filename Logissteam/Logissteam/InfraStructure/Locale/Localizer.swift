//
//  Localizer.swift
//  Maintenance
//
//  Created by Ahmed abu elregal on 02/12/2023.
//

import UIKit

extension UIApplication {
    class func isRTL() -> Bool{
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

class AppLocalizer: NSObject {
    class func DoTheMagic() {
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
    }
}

extension UIApplication {
    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if Language.isRTL {
                direction = .rightToLeft
            }
            return direction
        }
    }
}

extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = Language.currentAppleLanguage()
            var bundle = Bundle();
            if let _path = Bundle.main.path(forResource: Language.currentAppleLanguageFull(), ofType: "lproj") {
                bundle = Bundle(path: _path)!
            }else
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } else {
                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: _path)!
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}

/// Exchange the implementation of two methods of the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    guard let origMethod: Method = class_getInstanceMethod(cls, originalSelector),
        let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector) else {
        return
    }
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text?.localized
        self.font = self.font.appFont()
        self.adjustsFontSizeToFitWidth = false
        if self.textAlignment == .center { return }
        if Language.isRTL {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
    
    @objc func customSetText(text: String) {
        self.customSetText(text: text.localized)
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text?.localized
        self.placeholder = self.placeholder?.localized
        self.font = self.font?.appFont()
        if self.textAlignment == .center { return }
        if Language.isRTL {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
}

extension GrowingTextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text?.localized
        self.font =  self.font?.appFont()
        if self.textAlignment == .center { return }
        if Language.isRTL {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
}

extension UITextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text?.localized
        self.font =  self.font?.appFont()
        if self.textAlignment == .center { return }
        if Language.isRTL {
            if self.textAlignment == .right { return }
            self.textAlignment = .right
        } else {
            if self.textAlignment == .left { return }
            self.textAlignment = .left
        }
    }
}

extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let label = titleLabel, let text =  label.text {
            label.font = label.font.appFont()
            setTitle(text.localized, for: .normal)
        }
        if self.contentHorizontalAlignment == .center { return }
        if self.contentHorizontalAlignment == .right && Language.isRTL {
            self.contentHorizontalAlignment = .left
            return
        }
        if self.contentHorizontalAlignment == .left && Language.isRTL {
            self.contentHorizontalAlignment = .right
            return
        }
    }
}
