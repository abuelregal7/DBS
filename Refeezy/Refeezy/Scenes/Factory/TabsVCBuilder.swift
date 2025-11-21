//
//  TabsVCBuilder.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 07/04/2025.
//

import Foundation
import UIKit

final class TabsDependencyFactory {
    static let shared = TabsDependencyFactory()
    
    private init() {}
    
    // ✅ MARK: - Data Sources
    private let apiClient = NetworkManager.shared
    
    // ✅ MARK: - Repositories
    func makeTabsRepository() -> TabsRepositoryProtocol {
        let mapper: TabsMapperProtocol = TabsMapper()
        let remoteDataSource = TabsRemoteDataSource(apiClient: apiClient, mapper: mapper)
        return TabsRepository(remoteDataSource: remoteDataSource, mapper: mapper)
    }
    
    // MARK: - Home
    // ✅ MARK: - Use Cases
    func makeHomeSliderUseCase() -> HomeSliderUseCase {
        return HomeSliderUseCase(repository: makeTabsRepository())
    }
    
    func makeHomeRoomsUseCase() -> HomeRoomsUseCase {
        return HomeRoomsUseCase(repository: makeTabsRepository())
    }
    
    func makeHomeGiftsUseCase() -> HomeGiftsUseCase {
        return HomeGiftsUseCase(repository: makeTabsRepository())
    }
    
    func makeHomeCompletedRoomsUseCase() -> HomeCompletedRoomsUseCase {
        return HomeCompletedRoomsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(homeSliderUseCase: makeHomeSliderUseCase(), homeRoomsUseCase: makeHomeRoomsUseCase(), homeGiftsUseCase: makeHomeGiftsUseCase(), homeCompletedRoomsUseCase: makeHomeCompletedRoomsUseCase())
    }
    
    // ✅ MARK: - Home ViewControllers
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }
    
    // MARK: - Roomes
    // ✅ MARK: - Use Cases
    func makeRoomesUseCase() -> AllRoomesUseCase {
        return AllRoomesUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeRoomesViewModel() -> RoomesViewModel {
        return RoomesViewModel(roomesUseCase: makeRoomesUseCase())
    }
    
    // ✅ MARK: - Rooms ViewControllers
    func makeRoomesViewController() -> RoomsViewController {
        return RoomsViewController(viewModel: makeRoomesViewModel())
    }
    
    // MARK: - RoomsSearch
    // ✅ MARK: - Use Cases
    func makeRoomsSearchUseCase() -> AllRoomesUseCase {
        return AllRoomesUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeRoomsSearchViewModel() -> RoomesViewModel {
        return RoomesViewModel(roomesUseCase: makeRoomesUseCase())
    }
    
    // ✅ MARK: - Rooms ViewControllers
    func makeRoomesSearchViewController() -> RoomsSearchViewController {
        return RoomsSearchViewController(viewModel: makeRoomsSearchViewModel())
    }
    
    // MARK: - Gifts
    // ✅ MARK: - Use Cases
    func makeGiftsUseCase() -> HomeGiftsUseCase {
        return HomeGiftsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeGiftsViewModel() -> GiftsViewModel {
        return GiftsViewModel(giftsUseCase: makeGiftsUseCase())
    }
    
    // ✅ MARK: - Gifts ViewControllers
    func makeGiftsViewController() -> GiftsViewController {
        return GiftsViewController(viewModel: makeGiftsViewModel())
    }
    
    // MARK: - More
    // ✅ MARK: - Use Cases
    func makeLogoutUseCase() -> LogoutUseCase {
        return LogoutUseCase(repository: makeTabsRepository())
    }
    
    func makeDeleteAccountUseCase() -> DeleteAccountUseCase {
        return DeleteAccountUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeMoreViewModel() -> MoreViewModel {
        return MoreViewModel(logoutUseCase: makeLogoutUseCase(), deleteAccountUseCase: makeDeleteAccountUseCase())
    }
    
    // ✅ MARK: - More ViewControllers
    func makeMoreViewController() -> MoreViewController {
        return MoreViewController(viewModel: makeMoreViewModel())
    }
    
    // MARK: - MyAddresses
    // ✅ MARK: - Use Cases
    func makeMyAddressesUseCase() -> MyAddressesUseCase {
        return MyAddressesUseCase(repository: makeTabsRepository())
    }
    
    func makeDeleteAddressesUseCase() -> DeleteAddressUseCase {
        return DeleteAddressUseCase(repository: makeTabsRepository())
    }
    
    func makeAddressDefualtUseCase() -> MakeAddressDefualtUseCase {
        return MakeAddressDefualtUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - MyAddressesViewModels
    func makeMyAddressesViewModel() -> MyAddressesViewModel {
        return MyAddressesViewModel(myAddressesUseCase: makeMyAddressesUseCase(), deleteAddressUseCase: makeDeleteAddressesUseCase(), makeAddressDefualtUseCase: makeAddressDefualtUseCase())
    }
    
    // ✅ MARK: - MyAddresses ViewControllers
    func makeMyAddressesViewController() -> MyAddressesViewController {
        return MyAddressesViewController(viewModel: makeMyAddressesViewModel())
    }
    
    // MARK: - AddNewAddress
    // ✅ MARK: - Use Cases
    func makeAddNewAddressUseCase() -> AddAddressUseCase {
        return AddAddressUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeAddNewAddressViewModel(address: String?, city: String?, lat: String?, long: String?) -> AddNewAddressViewModel {
        return AddNewAddressViewModel(addAddressUseCase: makeAddNewAddressUseCase(), address: address, city: city, lat: lat, long: long)
    }
    
    // ✅ MARK: - AddNewAddress ViewControllers
    func makeAddNewAddressViewController(address: String?, city: String?, lat: String?, long: String?) -> AddNewAddressViewController {
        return AddNewAddressViewController(viewModel: makeAddNewAddressViewModel(address: address, city: city, lat: lat, long: long))
    }
    
    // MARK: - MyAccount
    // ✅ MARK: - Use Cases
    func makeProfileUseCase() -> ProfileUseCase {
        return ProfileUseCase(repository: makeTabsRepository())
    }
    
    func makeUpdateProfileUseCase() -> UpdateProfileUseCase {
        return UpdateProfileUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeAddNewAddressViewModel() -> MyAccountViewModel {
        return MyAccountViewModel(profileUseCase: makeProfileUseCase(), updateProfileUseCase: makeUpdateProfileUseCase())
    }
    
    // ✅ MARK: - MyAccount ViewControllers
    func makeMyAccountViewController() -> MyAccountViewController {
        return MyAccountViewController(viewModel: makeAddNewAddressViewModel())
    }
    
    // MARK: - ContactUS
    // ✅ MARK: - Use Cases
    func makeContactUSUseCase() -> ContactUsUseCase {
        return ContactUsUseCase(repository: makeTabsRepository())
    }
    
    func makeSettingUseCase() -> SettingUseCase {
        return SettingUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeContactUSViewModel() -> ContactUSViewModel {
        return ContactUSViewModel(settingUseCase: makeSettingUseCase(), contactUSUseCase: makeContactUSUseCase())
    }
    
    // ✅ MARK: - AddNewAddress ViewControllers
    func makeContactUSViewController() -> ContactUsViewController {
        return ContactUsViewController(viewModel: makeContactUSViewModel())
    }
    
    // MARK: - RoomDetails
    // ✅ MARK: - Use Cases
    func makeRoomDetailsUseCase() -> RoomeDetailsUseCase {
        return RoomeDetailsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeRoomDetailsViewModel(roomID: Int?) -> RoomDetailsViewModel {
        return RoomDetailsViewModel(roomeDetailsUseCase: makeRoomDetailsUseCase(), roomID: roomID)
    }
    
    // ✅ MARK: - RoomDetails ViewControllers
    func makeRoomDetailsViewController(roomID: Int?) -> RoomDetailsViewController {
        return RoomDetailsViewController(viewModel: makeRoomDetailsViewModel(roomID: roomID))
    }
    
    // MARK: - MyOrderes
    // ✅ MARK: - Use Cases
    func makeMyOrderesUseCase() -> MyOrderesUseCase {
        return MyOrderesUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeMyOrderesViewModel() -> CurrentPreviousRequestsViewModel {
        return CurrentPreviousRequestsViewModel(myOrderesUseCase: makeMyOrderesUseCase())
    }
    
    // ✅ MARK: - MyOrderes ViewControllers
    func makeMyOrderesViewController() -> CurrentPreviousRequestsViewController {
        return CurrentPreviousRequestsViewController(viewModel: makeMyOrderesViewModel())
    }
    
    // MARK: - RoomItems
    // ✅ MARK: - Use Cases
    func makeRoomItemsUseCase() -> RoomItemsUseCase {
        return RoomItemsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeRoomItemsViewModel(roomID: Int?, price: Double?) -> ChooseProductsViewModel {
        return ChooseProductsViewModel(roomItemsUseCase: makeRoomItemsUseCase(), roomID: roomID, price: price)
    }
    
    // ✅ MARK: - RoomItems ViewControllers
    func makeRoomItemsViewController(roomID: Int?, price: Double?) -> ChooseProductsViewController {
        return ChooseProductsViewController(viewModel: makeRoomItemsViewModel(roomID: roomID, price: price))
    }
    
    // MARK: - FirstPaymentOperation
    
    // ✅ MARK: - Use Cases
    func makeFirstPaymentOperationUseCase() -> PlaceOrderUseCase {
        return PlaceOrderUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeFirstPaymentOperationViewModel(productsData: [RoomItemsDataData]?, roomID: Int?) -> FirstPaymentOperationViewModel {
        return FirstPaymentOperationViewModel(placeOrderUseCase: makeFirstPaymentOperationUseCase(), productsData: productsData, roomID: roomID)
    }
    
    // ✅ MARK: - FirstPaymentOperation ViewControllers
    func makeFirstPaymentOperationViewController(productsData: [RoomItemsDataData]?, roomID: Int?) -> FirstPaymentOperationViewController {
        return FirstPaymentOperationViewController(viewModel: makeFirstPaymentOperationViewModel(productsData: productsData, roomID: roomID))
    }
    
    // MARK: - FirstRequestDetails
    // ✅ MARK: - Use Cases
    func makeFirstRequestDetailsUseCase() -> MyOrderDetailsUseCase {
        return MyOrderDetailsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeFirstRequestDetailsViewModel(roomID: Int?) -> FirstRequestDetailsViewModel {
        return FirstRequestDetailsViewModel(myOrderDetailsUseCase: makeFirstRequestDetailsUseCase(), roomID: roomID)
    }
    
    // ✅ MARK: - FirstRequestDetails ViewControllers
    func makeFirstRequestDetailsViewController(roomID: Int?) -> FirstRequestDetailsViewController {
        return FirstRequestDetailsViewController(viewModel: makeFirstRequestDetailsViewModel(roomID: roomID))
    }
    
    // MARK: - SecondRequestDetails
    // ✅ MARK: - Use Cases
    func makeSecondRequestDetailsUseCase() -> MyOrderDetailsUseCase {
        return MyOrderDetailsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeSecondRequestDetailsViewModel(roomID: Int?) -> SecondRequestDetailsViewModel {
        return SecondRequestDetailsViewModel(myOrderDetailsUseCase: makeSecondRequestDetailsUseCase(), roomID: roomID)
    }
    
    // ✅ MARK: - SecondRequestDetails ViewControllers
    func makeSecondRequestDetailsViewController(roomID: Int?) -> SecondRequestDetailsViewController {
        return SecondRequestDetailsViewController(viewModel: makeSecondRequestDetailsViewModel(roomID: roomID))
    }
    
    // MARK: - AboutUS
    // ✅ MARK: - Use Cases
    func makeAboutUSUseCase() -> AboutUsUseCase {
        return AboutUsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeAboutUSViewModel() -> WhoUSViewModel {
        return WhoUSViewModel(aboutUSUseCase: makeAboutUSUseCase())
    }
    
    // ✅ MARK: - AboutUS ViewControllers
    func makeAboutUSViewController() -> WhoUSViewController {
        return WhoUSViewController(viewModel: makeAboutUSViewModel())
    }
    
    // MARK: - Terms
    // ✅ MARK: - Use Cases
    func makeTermsUseCase() -> TermsConditionsUseCase {
        return TermsConditionsUseCase(repository: makeTabsRepository())
    }
    
    // ✅ MARK: - ViewModels
    func makeAboutUSViewModel() -> TermsConditionsViewModel {
        return TermsConditionsViewModel(termsConditionsUseCase: makeTermsUseCase())
    }
    
    // ✅ MARK: - Terms ViewControllers
    func makeTermsViewController() -> TermsConditionsViewController {
        return TermsConditionsViewController(viewModel: makeAboutUSViewModel())
    }
    
}

enum TabsVCBuilder {
    
    // MARK: - Cases
    case home
    case rooms
    case roomsSearch(dismiss: ((Int?) -> Void)?)
    case gifts
    case more
    case myAddresses
    case addNewAddress(Reload: (() -> Void)?, address: String?, city: String?, lat: String?, long: String?)
    case myAccount
    case contactUS
    case roomDetails(roomID: Int?)
    case myOrderes
    case roomItems(roomID: Int?, price: Double?)
    case firstPaymentOperation(productsData: [RoomItemsDataData]?, roomID: Int?)
    case firstRequestDetails(roomID: Int?)
    case secondRequestDetails(roomID: Int?)
    case aboutUS
    case terms
    
    // MARK: - ViewControllers
    var viewController: UIViewController {
        switch self {
        case .home:
            let vc = TabsDependencyFactory.shared.makeHomeViewController()
            return vc
        case .rooms:
            let vc = TabsDependencyFactory.shared.makeRoomesViewController()
            return vc
        case .roomsSearch(let dismiss):
            let vc = TabsDependencyFactory.shared.makeRoomesSearchViewController()
            vc.dismiss = dismiss
            return vc
        case .gifts:
            let vc = TabsDependencyFactory.shared.makeGiftsViewController()
            return vc
        case .more:
            let vc = TabsDependencyFactory.shared.makeMoreViewController()
            return vc
        case .myAddresses:
            let vc = TabsDependencyFactory.shared.makeMyAddressesViewController()
            return vc
        case .addNewAddress(let Reload, let address, let city, let lat, let long):
            let vc = TabsDependencyFactory.shared.makeAddNewAddressViewController(address: address, city: city, lat: lat, long: long)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.Reload = Reload
            return vc
        case .myAccount:
            let vc = TabsDependencyFactory.shared.makeMyAccountViewController()
            return vc
        case .contactUS:
            let vc = TabsDependencyFactory.shared.makeContactUSViewController()
            return vc
        case .roomDetails(let roomID):
            let vc = TabsDependencyFactory.shared.makeRoomDetailsViewController(roomID: roomID)
            return vc
        case .myOrderes:
            let vc = TabsDependencyFactory.shared.makeMyOrderesViewController()
            return vc
        case .roomItems(let roomID, let price):
            let vc = TabsDependencyFactory.shared.makeRoomItemsViewController(roomID: roomID, price: price)
            return vc
        case .firstPaymentOperation(let productsData, let roomID):
            let vc = TabsDependencyFactory.shared.makeFirstPaymentOperationViewController(productsData: productsData, roomID: roomID)
            return vc
        case .firstRequestDetails(let roomID):
            let vc = TabsDependencyFactory.shared.makeFirstRequestDetailsViewController(roomID: roomID)
            return vc
        case .secondRequestDetails(let roomID):
            let vc = TabsDependencyFactory.shared.makeSecondRequestDetailsViewController(roomID: roomID)
            return vc
        case .aboutUS:
            let vc = TabsDependencyFactory.shared.makeAboutUSViewController()
            return vc
        case .terms:
            let vc = TabsDependencyFactory.shared.makeTermsViewController()
            return vc
        }
    }
}
