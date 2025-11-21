//
//  UITextView_Extensions.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit

extension UITextView {

    private class PlaceholderLabel: UILabel { }
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            label.textColor = color
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholderString: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue.localized
            placeholderLabel.numberOfLines = 0
            placeholderLabel.textAlignment = .natural
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            placeholderLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: textContainer.lineFragmentPadding).isActive = true
            placeholderLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: textContainer.lineFragmentPadding).isActive = true
            placeholderLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                  constant: textContainer.lineFragmentPadding).isActive = true
            placeholderLabel.sizeToFit()
            textStorage.delegate = self
        }
    }
}

extension UITextView: NSTextStorageDelegate {
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}

extension UITextView {
    func formatTextWithMaxCount(_ range: NSRange, _ string: String, count: Int, anyOtherCondition: ((String) -> Bool)? = nil) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = self.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // make sure the result is under 16 characters
        return updatedText.count <= count && anyOtherCondition?(updatedText) ?? true
    }
}
