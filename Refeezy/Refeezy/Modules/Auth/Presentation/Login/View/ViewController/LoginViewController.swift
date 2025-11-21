//
//  LoginViewController.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 06/03/2025.
//

import UIKit

class LoginViewController: BaseViewControllerWithVM<LoginViewModel> {
    
    @IBOutlet weak var mobileNumberTF: LimitedLengthField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumberTF.becomeFirstResponder()
    }
    
    override func bind() {
        super.bind()
        
        mobileNumberTF.creatTextFieldBinding(with: viewModel.textPhoneSubject, storeIn: &cancellables)
        
        viewModel.navigatoToVerificationCode
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.navigationController?.pushViewController(AuthVCBuilder.VerificationCode(phoneNumber: mobileNumberTF.text).viewController, animated: true)
            }
            .store(in: &cancellables)
        
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
        
        skipButton
            .publisher(for: .touchUpInside)
            .receive(on: RunLoop.main)
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                guard let self else { return }
                self.set(TabBarViewController())
            }
            .store(in: &cancellables)
        
    }
    
}
