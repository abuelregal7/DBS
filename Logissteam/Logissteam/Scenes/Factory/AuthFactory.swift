//
//  AuthFactory.swift
//  Wala
//
//  Created by Ibrahim Nabil on 06/02/2024.
//

import Foundation
import UIKit

enum AuthVCBuilder {
    
    // MARK: Cases
    case splash
    case login
    case register
    case verificationCode(phoneNumber: String?)

    // MARK: Variables
    private var authRepo: AuthRepositoryProtocol {
        return AuthRepository(apiClient: NetworkManager())
    }
    
    // MARK: ViewControllers
    var viewController: UIViewController {
        switch self {
        case .splash:
            let vc = SplashViewController()
            return vc
            
        case .login:
            let loginUseCase = LoginUseCase(repository: authRepo)
            let vm = LoginViewModel(loginUseCase: loginUseCase)
            let vc = LoginViewController(viewModel: vm)
            return vc
            
        case .register:
            let registerUseCase = RegisterUseCase(repository: authRepo)
            let vm = RegisterViewModel(registerUseCase: registerUseCase)
            let vc = RegisterViewController(viewModel: vm)
            return vc
            
        case .verificationCode(let phoneNumber):
            let verificationCodeUseCase = VerificationCodeUseCase(repository: authRepo)
            let vm = VerificationCodeViewModel(verificationCodeUseCase: verificationCodeUseCase, phoneNumber: phoneNumber)
            let vc = VerificationCodeViewController(viewModel: vm)
            return vc
            
        }
    }
}
