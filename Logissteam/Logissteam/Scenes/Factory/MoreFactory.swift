//
//  MoreFactory.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import UIKit

enum MoreFactory {
    
    // MARK: Cases
    case baseMore
    case aboutUS
    case termsConditions
    case privacyPolicy
    case contactUS

    //MARK: Variables
    private var tabsRepo: TabsRepositoryProtocol {
        return TabsRepository(apiClient: NetworkManager())
    }
    
    // MARK: ViewControllers
    var viewController: UIViewController {
        switch self {
        case .baseMore:
            let vm = BaseMoreViewModel()
            let vc = MoreViewController(viewModel: vm)
            return vc
            
        case .aboutUS:
            let aboutUsUseCase = AboutUsUseCase(repository: tabsRepo)
            let vm = AboutUSViewModel(aboutUSUseCase: aboutUsUseCase)
            let vc = AboutUSViewController(viewModel: vm)
            return vc
            
        case .termsConditions:
            let termsConditionsUseCase = TermsConditionsUseCase(repository: tabsRepo)
            let vm = TermsConditionsViewModel(termsConditionsUseCase: termsConditionsUseCase)
            let vc = TermsConditionsViewController(viewModel: vm)
            return vc
            
        case .privacyPolicy:
            let privacyPolicyUseCase = PrivacyPolicyUseCase(repository: tabsRepo)
            let vm = PrivacyPolicyViewModel(privacyPolicyUseCase: privacyPolicyUseCase)
            let vc = PrivacyPolicyViewController(viewModel: vm)
            return vc
            
        case .contactUS:
            let contactUsUseCase = ContactUsUseCase(repository: tabsRepo)
            let vm = ContactUSViewModel(contactUSUseCase: contactUsUseCase)
            let vc = ContactUSViewController(viewModel: vm)
            return vc
            
        }
    }
}
