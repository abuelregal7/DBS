//
//  MyAccountFactory.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import UIKit

enum MyAccountFactory {
    
    // MARK: Cases
    case baseMyAccount
    case appLanguage
    case editeProfile

    // MARK: Variables
    private var authRepo: AuthRepositoryProtocol {
        return AuthRepository(apiClient: NetworkManager())
    }
    
    private var tabsRepo: TabsRepositoryProtocol {
        return TabsRepository(apiClient: NetworkManager())
    }
    
    // MARK: ViewControllers
    var viewController: UIViewController {
        switch self {
            
        case .baseMyAccount:
            let logoutUsecase = LogoutUseCase(repository: authRepo)
            let deleteAccountUsecase = DeleteAccountUseCase(repository: authRepo)
            let vm = BaseMyAccountViewModel(logoutUseCase: logoutUsecase, deleteAccountUseCase: deleteAccountUsecase)
            let vc = BaseMyAccountViewController(viewModel: vm)
            return vc
            
        case .appLanguage:
            let vc = ChangeLanguageViewController()
            return vc
            
        case .editeProfile:
            let profileUseCase = ProfileUseCase(repository: tabsRepo)
            let updateProfileUseCase = UpdateProfileUseCase(repository: tabsRepo)
            let vm = EditProfileViewModel(profileUseCase: profileUseCase, updateProfileUseCase: updateProfileUseCase)
            let vc = EditeProfileViewController(viewModel: vm)
            return vc
            
        }
    }
}
