//
//  FirstPaymentOperationViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 02/04/2025.
//

import UIKit
import MoyasarSdk
import SwiftUI
import PassKit

class FirstPaymentOperationViewController: BaseViewControllerWithVM<FirstPaymentOperationViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsTableView: UITableView!{
        didSet {
            productsTableView.delegate = self
            productsTableView.dataSource = self
            productsTableView.register(UINib(nibName: "FirstPaymentOperationProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "FirstPaymentOperationProductsTableViewCell")
        }
    }
    
    @IBOutlet weak var mapCheckBoxIcon: UIImageView!
    @IBOutlet weak var addressCheckBoxIcon: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var containerViewOfOnlinePayment: UIView!
    @IBOutlet weak var onlineCheckBoxIcon: UIImageView!
    
    @IBOutlet weak var applePayCheckBoxIcon: UIImageView!
    @IBOutlet weak var containerViewOfApplePayPayment: UIView!
    
    @IBOutlet weak var containerViewOfSelectMap: UIView!
    @IBOutlet weak var containerViewOfAddAddress: UIView!
    
    @IBOutlet weak var parentContainerViewOfSelectMap: UIView!
    @IBOutlet weak var parentContainerViewOfAddAddress: UIView!
    @IBOutlet weak var parentContainerOfAddNewAddressAndMakeDefaultAddress: UIView!
    
    
    @IBOutlet weak var containerStackViewOfPaymentInfo: UIStackView!
    @IBOutlet weak var nameOnCardTextField: LimitedLengthField!
    @IBOutlet weak var cardNumberTextField: LimitedLengthField!
    @IBOutlet weak var expiryDateTextField: LimitedLengthField!
    @IBOutlet weak var cvvTextField: LimitedLengthField!
    
    private var month: String?
    private var year: String?
    private var paymentType: PaymentType? = .CustomOnline
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expiryDateTextField.delegate = self
        cardNumberTextField.delegate = self
        cvvTextField.delegate = self
    }
    
    override func bind() {
        super.bind()
        
        if UD.address == nil {
            parentContainerViewOfSelectMap.isHidden = true
            parentContainerViewOfAddAddress.isHidden = true
            parentContainerOfAddNewAddressAndMakeDefaultAddress.isHidden = false
        }else {
            addressLabel.text = UD.address?.address
            parentContainerViewOfSelectMap.isHidden = false
            parentContainerViewOfAddAddress.isHidden = false
            parentContainerOfAddNewAddressAndMakeDefaultAddress.isHidden = true
        }
        
        viewModel.output.reloadProductsTable
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.productsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        buyNowButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                guard paymentType != nil else {
                    print("Select PaymentType first")
                    return
                }
                self.presentPaymentSheet(for: paymentType ?? .CustomOnline)
            }
            .store(in: &cancellables)
        
        containerViewOfSelectMap.addTapGesture { [weak self] in
            guard let self else { return }
            let vc = AddressMapViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
        
        containerViewOfAddAddress.addTapGesture { [weak self] in
            guard let self else { return }
            self.navigationController?.pushViewController(TabsVCBuilder.myAddresses.viewController, animated: true)
        }
        
        parentContainerViewOfSelectMap.addTapGesture { [weak self] in
            guard let self else { return }
            self.mapCheckBoxIcon.image = UIImage(named: "Checkboxbase")
            self.addressCheckBoxIcon.image = UIImage(named: "unCheckboxbase")
        }
        
        parentContainerViewOfAddAddress.addTapGesture { [weak self] in
            guard let self else { return }
            self.mapCheckBoxIcon.image = UIImage(named: "unCheckboxbase")
            self.addressCheckBoxIcon.image = UIImage(named: "Checkboxbase")
        }
        
        parentContainerOfAddNewAddressAndMakeDefaultAddress.addTapGesture { [weak self] in
            guard let self else { return }
            self.navigationController?.pushViewController(TabsVCBuilder.myAddresses.viewController, animated: true)
        }
        
        containerViewOfOnlinePayment.addTapGesture { [weak self] in
            guard let self else { return }
            self.onlineCheckBoxIcon.image = UIImage(named: "Checkboxbase")
            self.applePayCheckBoxIcon.image = UIImage(named: "unCheckboxbase")
            self.paymentType = .CustomOnline
            self.containerStackViewOfPaymentInfo.isHidden = false
        }
        
        containerViewOfApplePayPayment.addTapGesture { [weak self] in
            guard let self else { return }
            self.onlineCheckBoxIcon.image = UIImage(named: "unCheckboxbase")
            self.applePayCheckBoxIcon.image = UIImage(named: "Checkboxbase")
            self.paymentType = .ApplePay
            self.containerStackViewOfPaymentInfo.isHidden = true
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            self.productsTableViewHeight.constant = self.productsTableView.contentSize.height
            self.productsTableView.layoutIfNeeded()
        }
        
    }
    
    func presentPaymentSheet(for type: PaymentType) {
        let paymentVC = PaymentOptionsViewController(
            name: nameOnCardTextField.text,
            number: cardNumberTextField.text?.replacingOccurrences(of: " ", with: ""),
            month: month,
            year: year,
            cvc: cvvTextField.text,
            price: "5000")
        paymentVC.delegate = self
        paymentVC.paymentType = type
        
        if let sheet = paymentVC.sheetPresentationController {
            if type == .ApplePay {
                // Set the height to match the Apple Pay sheet height
                sheet.detents = [.medium()] // Or use `.large()` if needed
            } else if type == .CustomOnline {
                // Set the height to match the Apple Pay sheet height
                sheet.detents = [.medium()] // Or use `.large()` if needed
            } else {
                // Set a default height for other payment types
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            sheet.preferredCornerRadius = 24
            
        }
        
        present(paymentVC, animated: type == .ApplePay ? false : true)
    }
    
    func isValidExpiryDate(_ expiry: String) -> Bool {
        // Expected format: "MM/YY"
        let components = expiry.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]),
              components[0].count == 2, components[1].count == 2 else {
            return false
        }
        
        // Validate month
        guard (1...12).contains(month) else {
            return false
        }
        
        // Get current month and year (last 2 digits)
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate) % 100
        
        if year < currentYear {
            return false
        } else if year == currentYear {
            return month >= currentMonth
        }
        
        return true
    }
    
    func extractMonthYear(from expiry: String) -> (month: String, year: String)? {
        let components = expiry.split(separator: "/")
        guard components.count == 2 else { return nil }
        month = String(components[0])
        year = String(components[1])
        return (String(components[0]), String(components[1]))
    }
    
    func formatCardNumber(_ rawText: String) -> String {
        // Remove spaces from the raw text
        let rawText = rawText.replacingOccurrences(of: " ", with: "")
        
        // Add a space every 4 digits
        let formattedText = rawText.enumerated().map { index, character in
            return index % 4 == 0 && index != 0 ? " \(character)" : String(character)
        }.joined()
        
        return formattedText
    }
    
    func isValidCardNumber(_ cardNumber: String) -> Bool {
        let trimmed = cardNumber.replacingOccurrences(of: " ", with: "") // Remove spaces
        
        // Check if all characters are digits
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: trimmed)) else {
            return false
        }
        
        // Check length (Visa, MasterCard, etc. are usually 13-19 digits)
        guard trimmed.count >= 13 && trimmed.count <= 19 else {
            return false
        }
        
        // Luhn algorithm check
        return luhnCheck(trimmed)
    }
    
    func luhnCheck(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedDigits = cardNumber.reversed().map { String($0) }
        
        for (index, digitStr) in reversedDigits.enumerated() {
            guard let digit = Int(digitStr) else { return false }
            
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += (doubled > 9) ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
    
    func isValidCVV(_ cvv: String) -> Bool {
        // CVV should be 3 or 4 digits for Visa, MasterCard, etc.
        let regex = "^[0-9]{3,4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: cvv)
    }
    
}

extension FirstPaymentOperationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productsTableView.dequeueReusableCell(withIdentifier: "FirstPaymentOperationProductsTableViewCell", for: indexPath) as? FirstPaymentOperationProductsTableViewCell else { return UITableViewCell() }
        let item = viewModel.getProductsData(at: indexPath.row)
        cell.configure(item: item)
        
        cell.DeleteAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.removeSelectedProduct(at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension FirstPaymentOperationViewController: PaymentOptionsDelegate {
    
    // MARK: - PaymentOptionsDelegate
    
    func didCompletePayment(_ message: String) {
        showAlert(title: "Payment Success", message: message) { [weak self] action in
            guard let self = self else { return }
            self.viewModel.input.didTapBuyNow.send()
        }
    }
    
    func didCompletePayment(_ payment: ApiPayment) {
        showAlert(title: "Payment Success", message: "Payment ID: \(payment.id)")
    }
    
    func didFailPayment(_ message: String) {
        showAlert(title: "Payment Failed", message: message)
    }
    
    func didCancelPayment() {
        showAlert(title: "Canceled", message: "User canceled the payment")
    }
    
    func didReceiveToken(_ token: ApiToken) {
        showAlert(title: "Token Received", message: "Token ID: \(token.id)")
    }
    
}

extension FirstPaymentOperationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expiryDateTextField {
            guard let text = textField.text else { return true }
            
            if string.isEmpty {
                return true
            }
            
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
            
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            let cleanText = newText.replacingOccurrences(of: "/", with: "")
            
            if cleanText.count > 4 {
                return false
            }
            
            var formattedText = ""
            for (index, char) in cleanText.enumerated() {
                if index == 2 {
                    formattedText += "/"
                }
                formattedText += String(char)
            }
            
            textField.text = formattedText
            
            // 👇 Run extractMonthYear as user types
            if let result = extractMonthYear(from: formattedText), result.month.count == 2, result.year.count == 2 {
                print("🟢 Extracted month: \(result.month), year: \(result.year)")
                // You can add validation or assign to viewModel here
                
                if !isValidExpiryDate(formattedText) {
                    textField.layer.borderColor = UIColor.red.cgColor // Red border for invalid Expiry Date
                } else {
                    // Proceed with payment
                    textField.layer.borderColor = UIColor().colorWithHexString(hexString: "FFFFFF").withAlphaComponent(0.5).cgColor // Green border for valid Expiry Date
                }
            }
            
            return false
        }else if textField == cardNumberTextField {
            // Get the current text and append the new string
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Remove spaces from the raw text to validate length
            let rawText = newText.replacingOccurrences(of: " ", with: "")
            
            // Check if the card number exceeds the maximum length
            if rawText.count > 19 {
                return false // Reject the input if it exceeds 19 digits
            }
            
            // Check if the number starts with 4 (Visa) or 5 (Mastercard)
            if let firstDigit = rawText.first {
                if firstDigit == "4" { // Visa card
                    if rawText.count > 16 { // Limit Visa cards to 16 digits
                        return false
                    }
                } else if firstDigit == "5" { // Mastercard
                    if rawText.count > 16 { // Limit Mastercard cards to 16 digits
                        return false
                    }
                } else {
                    return false // Reject card numbers that don't start with 4 or 5
                }
            }
            
            // Add spaces every 4 digits for formatting
            let formattedText = formatCardNumber(rawText)
            
            // Set the formatted text back into the text field
            textField.text = formattedText
            
            // Validate the card number in real-time
            if isValidCardNumber(rawText) {
                textField.layer.borderColor = UIColor().colorWithHexString(hexString: "FFFFFF").withAlphaComponent(0.5).cgColor // Green border for valid card number
            } else {
                textField.layer.borderColor = UIColor.red.cgColor // Red border for invalid card number
            }
            
            return false // Return false to avoid default text change, as we've already set the text
        } else if textField == cvvTextField {
            // Only allow numbers in CVV field (3 or 4 digits)
            let cleanText = (textField.text ?? "") + string
            if cleanText.count > 4 {
                return false // Reject if CVV exceeds 4 digits
            }
            
            // Only allow digits
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
            
            //Validate CVV in real-time
            if isValidCVV(cleanText) {
                textField.layer.borderColor = UIColor().colorWithHexString(hexString: "FFFFFF").withAlphaComponent(0.5).cgColor // Green border for valid CVV
            } else {
                textField.layer.borderColor = UIColor.red.cgColor // Red border for invalid CVV
            }
            
            return true
        } else {
            return true
        }
        
    }
    
}
