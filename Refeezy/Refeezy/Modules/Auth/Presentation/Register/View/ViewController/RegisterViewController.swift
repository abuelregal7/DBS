//
//  RegisterViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 06/03/2025.
//

import UIKit

class RegisterViewController: BaseViewControllerWithVM<RegisterViewModel> {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileNumberTF: LimitedLengthField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        nameTF.creatTextFieldBinding(with: viewModel.textNameSubject, storeIn: &cancellables)
        emailTF.creatTextFieldBinding(with: viewModel.textEmailSubject, storeIn: &cancellables)
        mobileNumberTF.creatTextFieldBinding(with: viewModel.textPhoneSubject, storeIn: &cancellables)
        
        loginButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        registerButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.nameTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter full name".localized)
                    return
                }
                guard self.emailTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter E-mail".localized)
                    return
                }
                guard self.emailTF.text?.isValidEmail == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid Email".localized)
                    return
                }
                guard self.mobileNumberTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter mobile number".localized)
                    return
                }
                guard self.mobileNumberTF.text?.isValidPhone == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid mobile number".localized)
                    return
                }
                self.viewModel.didTapOnRegisterButton()
                
            }
            .store(in: &cancellables)
        
        viewModel.navigatoToVerificationCode
                .receive(on: RunLoop.main)
                .sink { [weak self] isLoading in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(AuthVCBuilder.VerificationCode(phoneNumber: mobileNumberTF.text).viewController, animated: true)
                }
                .store(in: &cancellables)
        
    }
    
}
