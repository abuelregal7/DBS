//
//  UITextView+Localized.swift
//  BaseProgect
//
//  Created by Restart Technology on 15/09/2022.
//

import UIKit

extension UITextView {
    @IBInspectable var localizedText: String? {
        get {
            return text
        }
        set {
            text = newValue?.localized
        }
    }
    
    var localizedFont: UIFont {
        set {
            font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }get {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
}
