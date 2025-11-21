//
//  ContactUsViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 03/04/2025.
//

import UIKit

class ContactUsViewController: BaseViewControllerWithVM<ContactUSViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        nameTF.creatTextFieldBinding(with: viewModel.textNameSubject, storeIn: &cancellables)
        phoneTF.creatTextFieldBinding(with: viewModel.textPhoneSubject, storeIn: &cancellables)
        emailTF.creatTextFieldBinding(with: viewModel.textEmailSubject, storeIn: &cancellables)
        messageTF.creatTextFieldBinding(with: viewModel.textMessageSubject, storeIn: &cancellables)
        
        viewModel.input.viewDidLoad.send()
        
        viewModel.addressData
            .receive(on: RunLoop.main)
            .sink { [weak self] address in
                guard let self = self else { return }
                addressLabel.text = address
            }
            .store(in: &cancellables)
        
        viewModel.phoneData
            .receive(on: RunLoop.main)
            .sink { [weak self] phone in
                guard let self = self else { return }
                phoneNumberLabel.text = phone
            }
            .store(in: &cancellables)
        
        viewModel.emailData
            .receive(on: RunLoop.main)
            .sink { [weak self] email in
                guard let self = self else { return }
                emailLabel.text = email
            }
            .store(in: &cancellables)
        
        viewModel.makePop
            .receive(on: RunLoop.main)
            .sink { [weak self] msg in
                guard let self = self else { return }
                self.showNotificationBannerAlert(msg)
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        backButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        sendButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard self.nameTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter full name".localized)
                    return
                }
                
                guard self.phoneTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter mobile number".localized)
                    return
                }
                
                guard self.phoneTF.text?.isValidPhone == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid mobile number".localized)
                    return
                }
                
                guard self.emailTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Please, Enter the email")
                    return
                }
                
                guard self.emailTF.text?.isValidEmail == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid Email".localized)
                    return
                }
                
                guard self.messageTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Write your message".localized)
                    return
                }
                
                self.viewModel.didTapOnSendButton()
                
            }
            .store(in: &cancellables)
        
    }
    
}
