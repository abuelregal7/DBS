//
//  TabbarFactory.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import Foundation
import UIKit

enum TabbarFactory {
    
    // MARK: Cases
    case home
    case categoriesSearch(dismiss: ((Int?) -> Void)?)
    case categoryDetaisl(dealId: Int?)
    case buyDeal(dealId: Int?, planId: Int?, planTitle: String?, checkBoxSelect: String)
    case bookDeal(dealId: Int?, planId: Int?, planTitle: String?, checkBoxSelect: String)
    case successPopUp(CallBacks: (() -> Void)?)
    case purchasePlanes(dealId: Int?, CallBacks: ((Int, String) -> Void)?)
    case deals
    case dealDetails(dealId: Int?)
    case upcomingPayments(dealId: Int?)
    case contracts(dealId: Int?)
    case transferOwnership(dealId: Int?)
    case suceessTransfereOwnershipPopUp

    //MARK: Variables
    private var tabsRepo: TabsRepositoryProtocol {
        return TabsRepository(apiClient: NetworkManager())
    }
    
    // MARK: ViewControllers
    var viewController: UIViewController {
        switch self {
        case .home:
            let homeUseCase = HomeUseCase(repository: tabsRepo)
            let vm = HomeViewModel(homeUseCase: homeUseCase)
            let vc = HomeViewController(viewModel: vm)
            return vc
            
        case .categoriesSearch(let dismiss):
            let categorySearchUseCase = CategorySearchUseCase(repository: tabsRepo)
            let vm = CategoriesSearchViewModel(categorySearchUseCase: categorySearchUseCase)
            let vc = CategoriesSearchViewController(viewModel: vm)
            vc.dismiss = dismiss
            return vc
            
        case .categoryDetaisl(let dealId):
            let dealDetailsUseCase = DealDetailsUseCase(repository: tabsRepo)
            let dealsReservationUseCase = DealsReservationUseCase(repository: tabsRepo)
            let vm = CategoriesDetailsViewModel(dealDetailsUseCase: dealDetailsUseCase, dealReservationUseCase: dealsReservationUseCase, dealId: dealId, planId: nil, planTitle: nil, checkBoxSelect: "")
            let vc = CategoryDetailsViewController(viewModel: vm)
            return vc
            
        case .buyDeal(let dealId, let planId, let planTitle, let checkBoxSelect):
            let dealDetailsUseCase = DealDetailsUseCase(repository: tabsRepo)
            let dealsReservationUseCase = DealsReservationUseCase(repository: tabsRepo)
            let vm = CategoriesDetailsViewModel(dealDetailsUseCase: dealDetailsUseCase, dealReservationUseCase: dealsReservationUseCase, dealId: dealId, planId: planId, planTitle: planTitle, checkBoxSelect: checkBoxSelect)
            let vc = BuyTheDealViewController(viewModel: vm)
            return vc
            
        case .bookDeal(let dealId, let planId, let planTitle, let checkBoxSelect):
            let dealDetailsUseCase = DealDetailsUseCase(repository: tabsRepo)
            let dealsReservationUseCase = DealsReservationUseCase(repository: tabsRepo)
            let vm = CategoriesDetailsViewModel(dealDetailsUseCase: dealDetailsUseCase, dealReservationUseCase: dealsReservationUseCase, dealId: dealId, planId: planId, planTitle: planTitle, checkBoxSelect: checkBoxSelect)
            let vc = BookTheDealViewController(viewModel: vm)
            return vc
            
        case .successPopUp(let CallBacks):
            let vc = SuccessPOPUPViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.CallBacks = CallBacks
            return vc
            
        case .purchasePlanes(let dealId, let CallBacks):
            let buyPlansUseCase = BuyPlansUseCase(repository: tabsRepo)
            let vm = PurchasePlansViewModel(purchasePlansUseCase: buyPlansUseCase, dealId: dealId)
            let vc = PurchasePlansViewController(viewModel: vm)
            vc.CallBacks = CallBacks
            return vc
            
        case .deals:
            let myDealsUseCase = MyDealsUseCase(repository: tabsRepo)
            let vm = MyDealsViewModel(myDealsUseCase: myDealsUseCase)
            let vc = DealsViewController(viewModel: vm)
            return vc
            
        case .dealDetails(let dealId):
            let dealDetailsUseCase = DealDetailsUseCase(repository: tabsRepo)
            let dealsReservationUseCase = DealsReservationUseCase(repository: tabsRepo)
            let vm = CategoriesDetailsViewModel(dealDetailsUseCase: dealDetailsUseCase, dealReservationUseCase: dealsReservationUseCase, dealId: dealId, planId: nil, planTitle: nil, checkBoxSelect: "")
            let vc = DealDetailsViewController(viewModel: vm)
            return vc
            
        case .upcomingPayments(let dealId):
            let dealsPaymentsUseCase = DealsPaymentsUseCase(repository: tabsRepo)
            let vm = UpcomingPaymentsViewModel(upcomingPaymentsUseCase: dealsPaymentsUseCase, dealId: dealId)
            let vc = UpcomingPaymentsViewController(viewModel: vm)
            return vc
            
        case .contracts(let dealId):
            let dealsContractsUseCase = DealsContractsUseCase(repository: tabsRepo)
            let vm = ContractsViewModel(contractsUseCase: dealsContractsUseCase, dealId: dealId)
            let vc = ContractsViewController(viewModel: vm)
            return vc
            
        case .transferOwnership(let dealId):
            let transfereOwnershipUseCase = TransferOwnershipUseCase(repository: tabsRepo)
            let vm = TransferOwnershipViewModel(transfereOwnershipUseCase: transfereOwnershipUseCase, dealId: dealId)
            let vc = TransferOwnershipViewController(viewModel: vm)
            return vc
            
        case .suceessTransfereOwnershipPopUp:
            let vc = SuceessTransfereOwnershipViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            return vc
            
        }
    }
}
