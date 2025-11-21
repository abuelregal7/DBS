//
//  LoginViewController.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit

class LoginViewController: BaseViewControllerWithVM<LoginViewModel> {
    
    @IBOutlet weak var mobileNumberTF: LimitedLengthField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumberTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        mobileNumberTF.creatTextFieldBinding(with: viewModel.textPhoneSubject, storeIn: &cancellables)
        
        loginButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.mobileNumberTF.text?.isEmpty == false else {
                    self.showAlert(title: "", message: "Enter mobile number".localized)
                    return
                }
                guard self.mobileNumberTF.text?.isValidPhone == true else {
                    self.showAlert(title: "", message: "Please, Enter the valid mobile number".localized)
                    return
                }
                self.viewModel.didTapOnLoginButton()
            }
            .store(in: &cancellables)
        
        registerButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(AuthVCBuilder.register.viewController, animated: true)
            }
            .store(in: &cancellables)
        
//        viewModel.checkPhoneValidPublisher()
//            .sink { [weak self] enabled in
//                guard let self else { return }
//                if enabled == false {
//                    self.loginButton.isEnabled = false
//                }else {
//                    self.loginButton.isEnabled = true
//                }
//                self.loginButton.isEnabled = enabled
//            }
//            .store(in: &cancellables)
        
        viewModel.navigatoToVerificationCode
                .receive(on: RunLoop.main)
                .sink { [weak self] isLoading in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(AuthVCBuilder.verificationCode(phoneNumber: mobileNumberTF.text).viewController, animated: true)
                }
                .store(in: &cancellables)
        
    }
    
}
