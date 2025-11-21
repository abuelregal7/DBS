//
//  TabsRepositoryProtocol.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

protocol TabsRepositoryProtocol {
    func home(body: HomeDealsRequest) -> AnyPublisher<HomeData, NetworkError>
    func search(body: CategorySearchRequest) -> AnyPublisher<CategorySearchData, NetworkError>
    func contactUs(body: ContactUsRequest) -> AnyPublisher<ContactUsModel, NetworkError>
    func profile() -> AnyPublisher<ProfileData, NetworkError>
    func updateProfile(body: UpdateProfileRequest) -> AnyPublisher<UpdateProfileModel, NetworkError>
    func aboutUs() -> AnyPublisher<AboutUSData, NetworkError>
    func temsConditions() -> AnyPublisher<TermsData, NetworkError>
    func privacyPolicy() -> AnyPublisher<PrivacyPolicyData, NetworkError>
    func dealDetails(body: DealDetailsRequest) -> AnyPublisher<DealDetailsData, NetworkError>
    func myDeals(body: MyDealsRequest) -> AnyPublisher<MyDealsData, NetworkError>
    func buyPlans(body: BuyPlansRequest) -> AnyPublisher<[BuyPlansModelData], NetworkError>
    func dealsPayments(body: DealsPaymentsRequest) -> AnyPublisher<DealsPaymentsData, NetworkError>
    func dealsContracts(body: DealsContractsRequest) -> AnyPublisher<DealsContractsData, NetworkError>
    func transferOwnership(body: TransferOwnershipRequest) -> AnyPublisher<TransferOwnershipModel, NetworkError>
    func dealsReservation(body: DealsReservationRequest) -> AnyPublisher<DealsReservationModel, NetworkError>
}
