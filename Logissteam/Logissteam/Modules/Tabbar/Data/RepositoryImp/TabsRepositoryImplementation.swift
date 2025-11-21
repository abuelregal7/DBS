//
//  TabsRepositoryImplementation.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

class TabsRepository: TabsRepositoryProtocol {
    
    private let apiClient: NetworkLayerProtocol
    
    init(apiClient: NetworkLayerProtocol) {
        self.apiClient = apiClient
    }
}

extension TabsRepository {
    func home(body: HomeDealsRequest) -> AnyPublisher<HomeData, NetworkError> {
        let endPoint = TabsEndPoint.home(homeRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: HomeModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func search(body: CategorySearchRequest) -> AnyPublisher<CategorySearchData, NetworkError> {
        let endPoint = TabsEndPoint.search(categorySearchRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: CategorySearchModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func contactUs(body: ContactUsRequest) -> AnyPublisher<ContactUsModel, NetworkError> {
        let endPoint = TabsEndPoint.contactUs(contactUsRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: ContactUsModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    return response
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func profile() -> AnyPublisher<ProfileData, NetworkError> {
        let endPoint = TabsEndPoint.profile
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: ProfileModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func updateProfile(body: UpdateProfileRequest) -> AnyPublisher<UpdateProfileModel, NetworkError> {
        let endPoint = TabsEndPoint.updateProfile(updateProfileRequest: body)
        
        // Setup upload data if required
        var uploadData: UploadDataModel?
        if let ibanImage = body.iban_image {
            uploadData = UploadDataModel(
                fileName: "\(Date().timeIntervalSince1970)" + ".png",
                mimeType: "image/png",
                data: ibanImage,
                name: "iban_image"
            )
        }
        
        // Use Combine to handle the request and possible upload
        return apiClient.upload(endPoint, uploadData: uploadData)
            .tryMap { (response: UpdateProfileModel) in
                // Handle response status
                if response.status == 200 {
                    return response
                } else if (400...500).contains(response.status ?? 0) {
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert any other errors into NetworkError
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher() // Ensure the return type is AnyPublisher
    }
}

extension TabsRepository {
    func aboutUs() -> AnyPublisher<AboutUSData, NetworkError> {
        let endPoint = TabsEndPoint.aboutUs
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: AboutUSModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func temsConditions() -> AnyPublisher<TermsData, NetworkError> {
        let endPoint = TabsEndPoint.termsContidtions
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: TermsModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func privacyPolicy() -> AnyPublisher<PrivacyPolicyData, NetworkError> {
        let endPoint = TabsEndPoint.privacyPolicy
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: PrivacyPolicyModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func dealDetails(body: DealDetailsRequest) -> AnyPublisher<DealDetailsData, NetworkError> {
        let endPoint = TabsEndPoint.dealDetails(dealDetailsRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: DealDetailsModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func myDeals(body: MyDealsRequest) -> AnyPublisher<MyDealsData, NetworkError> {
        let endPoint = TabsEndPoint.myDeals(myDealsRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: MyDealsModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func buyPlans(body: BuyPlansRequest) -> AnyPublisher<[BuyPlansModelData], NetworkError> {
        let endPoint = TabsEndPoint.buyPlans(buyPlansRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: BuyPlansModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func dealsPayments(body: DealsPaymentsRequest) -> AnyPublisher<DealsPaymentsData, NetworkError> {
        let endPoint = TabsEndPoint.dealsPayments(dealsPaymentsRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: DealsPaymentsModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func dealsContracts(body: DealsContractsRequest) -> AnyPublisher<DealsContractsData, NetworkError> {
        let endPoint = TabsEndPoint.dealsContracts(dealsContractsRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: DealsContractsModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    return data
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func transferOwnership(body: TransferOwnershipRequest) -> AnyPublisher<TransferOwnershipModel, NetworkError> {
        let endPoint = TabsEndPoint.transferOwnership(transferOwnershipRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: TransferOwnershipModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    return response
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension TabsRepository {
    func dealsReservation(body: DealsReservationRequest) -> AnyPublisher<DealsReservationModel, NetworkError> {
        let endPoint = TabsEndPoint.dealsReservation(dealsReservationRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: DealsReservationModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    return response
                } else if (400...500).contains(response.status ?? 0) {
                    // Handle specific errors
                    if response.status == 401 {
                        throw NetworkError.unauthorized
                    }
                    guard let errorMessage = response.message, !errorMessage.isEmpty else {
                        throw NetworkError.nullData
                    }
                    throw NetworkError.general(errorMessage)
                } else {
                    throw NetworkError.general(response.message ?? "")
                }
            }
            .mapError { error in
                // Convert to NetworkError if needed
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.general(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
