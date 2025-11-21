//
//  UIApplication_Extension.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UIApplication {
    
    static func set(style: UIUserInterfaceStyle) {
        (UIApplication.shared.delegate as! AppDelegate).window?.overrideUserInterfaceStyle = style
    }
    
    static func initWindow() {
        (UIApplication.shared.delegate as! AppDelegate).initWindow()
    }
    
    static func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    static func call(mobile: String) {
        guard let url = URL(string: "tel://\(mobile)") else {
            print("Invalid mobile number \(mobile)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    static func openURL(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // If the app is not installed, open in Safari
            if let safariURL = URL(string: urlString.replacingOccurrences(of: "://", with: "://www.")) {
                UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
            } else {
                print("Invalid URL or unable to open the URL.")
            }
        }
    }
    
    static func setRoot(_ controller: UIViewController, animated: Bool) {
        
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window  else {
            return
        }
        UIView.appearance().semanticContentAttribute = Language.isRTL ? .forceRightToLeft : .forceLeftToRight
        let rootVC = UINavigationController(rootViewController: controller)
        rootVC.navigationController?.setNavigationBarHidden(true, animated: false)
        rootVC.navigationController?.isNavigationBarHidden = true
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
        }
    }

    static func setRootWithoutNavigationController(_ controller: UIViewController, animated: Bool) {
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window  else {
            return
        }
        UIView.appearance().semanticContentAttribute = Language.isRTL ? .forceRightToLeft : .forceLeftToRight
        window.rootViewController = controller
        window.makeKeyAndVisible()
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
        }
    }
    
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
    
}
