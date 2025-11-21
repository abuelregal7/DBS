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

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 7.5
    @IBInspectable var bottomInset: CGFloat = 7.5
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
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
