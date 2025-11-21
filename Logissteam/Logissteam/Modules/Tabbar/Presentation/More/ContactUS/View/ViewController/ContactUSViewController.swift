//
//  ContactUSViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import UIKit

class ContactUSViewController: BaseViewControllerWithVM<ContactUSViewModel> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var messageTF: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        firstNameTF.creatTextFieldBinding(with: viewModel.textFirstNameSubject, storeIn: &cancellables)
        lastNameTF.creatTextFieldBinding(with: viewModel.textLastNameSubject, storeIn: &cancellables)
        emailTF.creatTextFieldBinding(with: viewModel.textEmailSubject, storeIn: &cancellables)
        messageTF.creatTextViewBinding(with: viewModel.textMessageSubject, storeIn: &cancellables)
        
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
                guard self.firstNameTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter first name".localized)
                    return
                }
                guard self.lastNameTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter last name".localized)
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
                //.isValidPhone .isValidEmail
//                if self.firstNameTF.text?.isEmpty == false && self.lastNameTF.text?.isEmpty == false && self.emailTF.text?.isEmpty == false && self.messageTF.text?.isEmpty == false {
//                    self.viewModel.didTapOnSendButton()
//                }
            }
            .store(in: &cancellables)
        
    }
    
}
