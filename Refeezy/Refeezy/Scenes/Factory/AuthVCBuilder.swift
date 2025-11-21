//
//  AuthVCBuilder.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import UIKit

final class AuthDependencyFactory {
    static let shared = AuthDependencyFactory()
    
    private init() {}
    
    // ✅ MARK: - Data Sources
    private let apiClient = NetworkManager.shared
    
    // ✅ MARK: - Repositories
    func makeTabsRepository() -> AuthRepositoryProtocol {
        let mapper: AuthMapperProtocol = AuthMapper()
        let remoteDataSource = AuthRemoteDataSource(apiClient: apiClient, mapper: mapper)
        return AuthRepository(remoteDataSource: remoteDataSource, mapper: mapper)
    }
    
    // MARK: - Login
    // ✅ MARK: - Use Cases
    func makeLoginUseCase() -> LoginUseCase {
        return LoginUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: makeLoginUseCase())
    }
    
    // ✅ MARK: - Login ViewControllers
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel())
    }
    
    // MARK: - VerificationCode
    // ✅ MARK: - Use Cases
    func makeVerificationCodeUseCase() -> VerificationCodeUseCase {
        return VerificationCodeUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeVerificationCodeViewModel(phoneNumber: String?) -> VerificationCodeViewModel {
        return VerificationCodeViewModel(verificationCodeUseCase: makeVerificationCodeUseCase(), phoneNumber: phoneNumber)
    }
    
    // ✅ MARK: - VerificationCode ViewControllers
    func makeVerificationCodesViewController(phoneNumber: String?) -> VerificationCodeViewController {
        return VerificationCodeViewController(viewModel: makeVerificationCodeViewModel(phoneNumber: phoneNumber))
    }
    
    // MARK: - Register
    // ✅ MARK: - Use Cases
    func makeRegisterUseCase() -> RegisterUseCase {
        return RegisterUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(registerUseCase: makeRegisterUseCase())
    }
    
    // ✅ MARK: - Register ViewControllers
    func makeRegisterViewController() -> RegisterViewController {
        return RegisterViewController(viewModel: makeRegisterViewModel())
    }
    
}

enum AuthVCBuilder {
    
    // MARK: - Cases
    case login
    case VerificationCode(phoneNumber: String?)
    case register
    
    // MARK: - ViewControllers
    var viewController: UIViewController {
        switch self {
        case .login:
            let vc = AuthDependencyFactory.shared.makeLoginViewController()
            return vc
            
        case .VerificationCode(let phoneNumber):
            let vc = AuthDependencyFactory.shared.makeVerificationCodesViewController(phoneNumber: phoneNumber)
            return vc
            
        case .register:
            let vc = AuthDependencyFactory.shared.makeRegisterViewController()
            return vc
        }
    }
}

