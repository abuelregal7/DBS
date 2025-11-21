//
//  UIButtonExtentions.swift
//  SmartLab
//
//  Created by Mahmoud Eissa on 7/24/19.
//  Copyright © 2019 Asgatech. All rights reserved.
//

import UIKit
extension UIImageView {
    @IBInspectable var isFlipInRTL: Bool {
        get {
            return image?.flipsForRightToLeftLayoutDirection ?? false
        }
        set {
            image = newValue ? image?.imageFlippedForRightToLeftLayoutDirection() : image
        }
    }
}

extension UIButton {
    @IBInspectable var isFlipInRTL: Bool {
        get {
            return imageView?.image?.flipsForRightToLeftLayoutDirection ?? false
        }
        set {
            setImage(
                newValue ? imageView?.image?.imageFlippedForRightToLeftLayoutDirection() : imageView?.image,
                     for: .normal)
        }
    }

    @IBInspectable public var underlined: Bool {
        set {
            let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : titleLabel?.textColor! as Any]
            let attStr = NSAttributedString.init(string: (titleLabel?.text?.localized)!, attributes: attrs)
            setTitleColor(titleLabel?.textColor!, for: .normal)
            setAttributedTitle(attStr, for: .normal)
        }
        get {
            return (titleLabel?.attributedText != nil)
        }
    }
    
    @IBInspectable public var isDimmed: Bool {
        set {
            self.alpha = newValue ? 0.5 : 1
        }
        get {
            return self.alpha == 0.3
        }
    }
}
