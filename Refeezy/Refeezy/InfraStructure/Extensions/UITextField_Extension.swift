//
//  UITextField_Extension.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import UIKit
import Combine

extension UITextField {
    var isEmpty: Bool {
        return (self.text?.isEmpty)! || self.text! == String(repeating: " ", count: self.text!.count)
    }
    
//    var textPublisher: AnyPublisher<String, Never> {
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: self)
//            .compactMap { [weak self] in
//                guard let self = self else { return }
//                $0.object as? UITextField
//            } // receiving notifications with objects which are instances of UITextFields
//            .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
//            .eraseToAnyPublisher()
//    }
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { notification -> UITextField? in
                return notification.object as? UITextField
            }
            .compactMap { $0.text }
            .eraseToAnyPublisher()
    }
    
    @IBInspectable var placeholderColor: UIColor {
        set {
            attributedPlaceholder = NSAttributedString(
                string: self.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: newValue]
            )
        }
        get {
            guard let color = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) [NSAttributedString.Key.foregroundColor] as? UIColor else { return .clear}
            return color
        }
    }
    
    func creatTextFieldBinding(with subject: CurrentValueSubject<String, Never> , storeIn subscripations: inout Set<AnyCancellable>){
        
        subject.sink { [weak self] value in
            guard let self = self else { return }
            if value != self.text {
                self.text = value
            }
        }.store(in: &subscripations)
        
        
        textPublisher.sink { value in
            if value != subject.value {
                subject.send(value)
            }
        }.store(in: &subscripations)
        
    }
    
    func creatTextFieldBindingOptional(with subject: CurrentValueSubject<String?, Never> , storeIn subscripations: inout Set<AnyCancellable>){
        
        subject.sink { [weak self] value in
            guard let self = self else { return }
            if value != self.text {
                self.text = value
            }
        }.store(in: &subscripations)
        
        
        textPublisher.sink { value in
            if value != subject.value {
                subject.send(value)
            }
        }.store(in: &subscripations)
        
    }
    
}

extension UITextView {
    
    func creatTextViewBinding(with subject: CurrentValueSubject<String, Never> , storeIn subscripations: inout Set<AnyCancellable>){
        
        subject.sink { [weak self] value in
            guard let self = self else { return }
            if value != self.text {
                self.text = value
            }
        }.store(in: &subscripations)
        
        
        textPublisher.sink { value in
            if value != subject.value {
                subject.send(value)
            }
        }.store(in: &subscripations)
        
    }
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextView } // receiving notifications with objects which are instances of UITextFields
            .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    func addInputViewDatePicker(
        target: Any,
        selector: Selector,
        minDate: Date = "1920-01-01".toDate
    ) {
        let screenWidth = UIScreen.main.bounds.width
        // Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = minDate
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.inputView = datePicker
        // Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(
            title: "Cancel".localized,
            style: .plain,
            target: self,
            action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(
            title: "Done".localized,
            style: .plain,
            target: target,
            action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}

extension UITextField {
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

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    @IBInspectable var leftPadding: CGFloat = 0
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
}

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
           if let left = left {
               let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
               self.leftView = paddingView
               self.leftViewMode = .always
           }
           
           if let right = right {
               let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
               self.rightView = paddingView
               self.rightViewMode = .always
           }
       }
    
      @IBInspectable var padding: CGFloat {
          get {
              return self.padding
          }
          set {
              let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.height))
              self.leftView = view
              self.leftViewMode = .always
              self.rightView = view
              self.rightViewMode = .always
          }
      }
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

@IBDesignable
class LimitedLengthField: UITextField {
    @IBInspectable
    var maxLength: Int = 10 { didSet { editingChanged(self) } }
    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged(self)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        editingChanged(self)
    }
    @objc func editingChanged(_ textField: UITextField) {
        textField.text = String(textField.text!.prefix(maxLength))
    }
}
