//
//  TabsRepositoryImplementation.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

class TabsRepository: TabsRepositoryProtocol {
    private let remoteDataSource: TabsRemoteDataSource
    private let mapper: TabsMapperProtocol
    
    init(remoteDataSource: TabsRemoteDataSource, mapper: TabsMapperProtocol) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
}

extension TabsRepository {
    func homeSlider() -> AnyPublisher<[HomeSliderData], NetworkError> {
        return remoteDataSource.homeSlider()
    }
}

extension TabsRepository {
    func homeRooms() -> AnyPublisher<[HomeRoomsData], NetworkError> {
        return remoteDataSource.homeRooms()
    }
}

extension TabsRepository {
    func homeGifts() -> AnyPublisher<[HomeGiftsData], NetworkError> {
        return remoteDataSource.homeGifts()
    }
}

extension TabsRepository {
    func homeCompletedRooms() -> AnyPublisher<[HomeCompletedRoomsData], NetworkError> {
        return remoteDataSource.homeCompletedRooms()
    }
}

extension TabsRepository {
    func allRoomes(body: AllRoomesRequest) -> AnyPublisher<AllRoomesData, NetworkError> {
        return remoteDataSource.allRoomes(body: body)
    }
}

extension TabsRepository {
    func myAddresses() -> AnyPublisher<[MyAddressesData], NetworkError> {
        return remoteDataSource.myAddresses()
    }
}

extension TabsRepository {
    func addAddress(body: AddAddressRequest) -> AnyPublisher<AddAddressModel, NetworkError> {
        return remoteDataSource.addAddress(body: body)
    }
}

extension TabsRepository {
    func deleteAddress(body: DeleteAddressRequest) -> AnyPublisher<DeleteAddressModel, NetworkError> {
        return remoteDataSource.deleteAddress(body: body)
    }
}

extension TabsRepository {
    func makeAddressDefualt(body: MakeAddressDefualtRequest) -> AnyPublisher<MakeAddressDefualtModel, NetworkError> {
        return remoteDataSource.makeAddressDefualt(body: body)
    }
}

extension TabsRepository {
    func profile() -> AnyPublisher<ProfileData, NetworkError> {
        return remoteDataSource.profile()
    }
}

extension TabsRepository {
    func updateProfile(body: UpdateProfileRequest) -> AnyPublisher<UpdateProfileModel, NetworkError> {
        return remoteDataSource.updateProfile(body: body)
    }
}

extension TabsRepository {
    func logout() -> AnyPublisher<LogoutModel, NetworkError> {
        return remoteDataSource.logout()
    }
}

extension TabsRepository {
    func deleteAccount() -> AnyPublisher<DeleteAccountModel, NetworkError> {
        return remoteDataSource.deleteAccount()
    }
}

extension TabsRepository {
    func contactUs(body: ContactUsRequest) -> AnyPublisher<ContactUsModel, NetworkError> {
        return remoteDataSource.contactUs(body: body)
    }
}

extension TabsRepository {
    func roomeDetails(body: RoomDetailsRequest) -> AnyPublisher<RoomDetailsData, NetworkError> {
        return remoteDataSource.roomeDetails(body: body)
    }
}

extension TabsRepository {
    func myOrderes(body: MyOrderesRequest) -> AnyPublisher<MyOrderesData, NetworkError> {
        return remoteDataSource.myOrderes(body: body)
    }
}

extension TabsRepository {
    func roomItems(body: RoomItemsRequest) -> AnyPublisher<RoomItemsData, NetworkError> {
        return remoteDataSource.roomItems(body: body)
    }
}

extension TabsRepository {
    func myOrderDetails(body: ShowOrdereRequest) -> AnyPublisher<ShowOrdereData, NetworkError> {
        return remoteDataSource.myOrderDetails(body: body)
    }
}

extension TabsRepository {
    func aboutUs() -> AnyPublisher<AboutUSData, NetworkError> {
        return remoteDataSource.aboutUs()
    }
}

extension TabsRepository {
    func temsConditions() -> AnyPublisher<TermsData, NetworkError> {
        return remoteDataSource.temsConditions()
    }
}

extension TabsRepository {
    func setting() -> AnyPublisher<[SettingData], NetworkError> {
        return remoteDataSource.setting()
    }
}

extension TabsRepository {
    func placeOrder(body: PlaceOrderRequest) -> AnyPublisher<PlaceOrderData, NetworkError> {
        return remoteDataSource.placeOrder(body: body)
    }
}

