//
//  TabsRepositoryProtocol.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

protocol TabsRepositoryProtocol {
    func homeSlider() -> AnyPublisher<[HomeSliderData], NetworkError>
    func homeRooms() -> AnyPublisher<[HomeRoomsData], NetworkError>
    func homeGifts() -> AnyPublisher<[HomeGiftsData], NetworkError>
    func homeCompletedRooms() -> AnyPublisher<[HomeCompletedRoomsData], NetworkError>
    func allRoomes(body: AllRoomesRequest) -> AnyPublisher<AllRoomesData, NetworkError>
    func myAddresses() -> AnyPublisher<[MyAddressesData], NetworkError>
    func addAddress(body: AddAddressRequest) -> AnyPublisher<AddAddressModel, NetworkError>
    func deleteAddress(body: DeleteAddressRequest) -> AnyPublisher<DeleteAddressModel, NetworkError>
    func makeAddressDefualt(body: MakeAddressDefualtRequest) -> AnyPublisher<MakeAddressDefualtModel, NetworkError>
    func profile() -> AnyPublisher<ProfileData, NetworkError>
    func updateProfile(body: UpdateProfileRequest) -> AnyPublisher<UpdateProfileModel, NetworkError>
    func logout() -> AnyPublisher<LogoutModel, NetworkError>
    func deleteAccount() -> AnyPublisher<DeleteAccountModel, NetworkError>
    func contactUs(body: ContactUsRequest) -> AnyPublisher<ContactUsModel, NetworkError>
    func roomeDetails(body: RoomDetailsRequest) -> AnyPublisher<RoomDetailsData, NetworkError>
    func myOrderes(body: MyOrderesRequest) -> AnyPublisher<MyOrderesData, NetworkError>
    func roomItems(body: RoomItemsRequest) -> AnyPublisher<RoomItemsData, NetworkError>
    func myOrderDetails(body: ShowOrdereRequest) -> AnyPublisher<ShowOrdereData, NetworkError>
    func aboutUs() -> AnyPublisher<AboutUSData, NetworkError>
    func temsConditions() -> AnyPublisher<TermsData, NetworkError>
    func setting() -> AnyPublisher<[SettingData], NetworkError>
    func placeOrder(body: PlaceOrderRequest) -> AnyPublisher<PlaceOrderData, NetworkError>
}
