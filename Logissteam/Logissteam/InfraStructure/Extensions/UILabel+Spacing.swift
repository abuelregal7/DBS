//
//  UILabel+Spacing.swift
//  BonTech
//
//  Created by Ahmed Abo Al-Regal on 01/01/2024.
//

import Foundation
import UIKit

@IBDesignable
extension UILabel {
    
    @IBInspectable var lineHeight: CGFloat {
        get {
            return 0
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = newValue
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.alignment = self.textAlignment
            
            let attrString = NSMutableAttributedString(string: self.text ?? "")
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    @IBInspectable var attributedlineHeight: CGFloat {
        get {
            return 0
        }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = newValue
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.alignment = self.textAlignment
            
            let attrString = NSMutableAttributedString(attributedString: self.attributedText ?? NSAttributedString(string: ""))
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    @IBInspectable var letterSpacing: CGFloat {
        get {
            return 0
        }
        set {
            let attrString = NSMutableAttributedString(string: self.text ?? "")
            attrString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attrString.length))
            self.attributedText = attrString
        }
    }
    
}

class PaddedLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width + 10, height: super.intrinsicContentSize.height)
    }
}

extension UILabel {
    @IBInspectable var underlined: Bool {
        get {
            return (attributedText?.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.underlineStyle] != nil)
        }
        set {
            if newValue {
                underlineLabel()
            } else {
                removeUnderline()
            }
        }
    }

    private func underlineLabel() {
        guard let currentText = text else { return }
        let attributedString = NSMutableAttributedString(string: currentText)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }

    private func removeUnderline() {
        guard let currentText = text else { return }
        let attributedString = NSMutableAttributedString(string: currentText)
        attributedString.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
