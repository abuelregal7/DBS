//
//  TabsRemoteDataSource.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

protocol TabsMapperProtocol {
    func mapHomeSliderResponseToDomain(_ response: HomeSliderModel) throws -> [HomeSliderData]
    func mapHomeRoomsResponseToDomain(_ response: HomeRoomsModel) throws -> [HomeRoomsData]
    func mapHomeGiftsResponseToDomain(_ response: HomeGiftsModel) throws -> [HomeGiftsData]
    func mapHomeCompletedRoomsResponseToDomain(_ response: HomeCompletedRoomsModel) throws -> [HomeCompletedRoomsData]
    func mapAllRoomsResponseToDomain(_ response: AllRoomesModel) throws -> AllRoomesData
    func mapMyAddressesResponseToDomain(_ response: MyAddressesModel) throws -> [MyAddressesData]
    func mapAddAddressResponseToDomain(_ response: AddAddressModel) throws -> AddAddressModel
    func mapDeleteAddressResponseToDomain(_ response: DeleteAddressModel) throws -> DeleteAddressModel
    func mapMakeAddressDefualtResponseToDomain(_ response: MakeAddressDefualtModel) throws -> MakeAddressDefualtModel
    func mapProfileResponseToDomain(_ response: ProfileModel) throws -> ProfileData
    func mapUpdateProfileResponseToDomain(_ response: UpdateProfileModel) throws -> UpdateProfileModel
    func mapLogoutResponseToDomain(_ response: LogoutModel) throws -> LogoutModel
    func mapDeleteAccountResponseToDomain(_ response: DeleteAccountModel) throws -> DeleteAccountModel
    func mapContactUsResponseToDomain(_ response: ContactUsModel) throws -> ContactUsModel
    func mapRoomDetailsResponseToDomain(_ response: RoomDetailsModel) throws -> RoomDetailsData
    func mapMyOrderesResponseToDomain(_ response: MyOrderesModel) throws -> MyOrderesData
    func mapRoomItemsResponseToDomain(_ response: RoomItemsModel) throws -> RoomItemsData
    func mapMyOrderDetailsResponseToDomain(_ response: ShowOrdereModel) throws -> ShowOrdereData
    func mapAboutUSResponseToDomain(_ response: AboutUSModel) throws -> AboutUSData
    func mapTermsConditionsResponseToDomain(_ response: TermsModel) throws -> TermsData
    func mapSettingResponseToDomain(_ response: SettingModel) throws -> [SettingData]
    func mapPlaceOrderResponseToDomain(_ response: PlaceOrderModel) throws -> PlaceOrderData
}
 
class TabsMapper: TabsMapperProtocol {
    func mapHomeSliderResponseToDomain(_ response: HomeSliderModel) throws -> [HomeSliderData] {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapHomeRoomsResponseToDomain(_ response: HomeRoomsModel) throws -> [HomeRoomsData] {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapHomeGiftsResponseToDomain(_ response: HomeGiftsModel) throws -> [HomeGiftsData] {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapHomeCompletedRoomsResponseToDomain(_ response: HomeCompletedRoomsModel) throws -> [HomeCompletedRoomsData] {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapAllRoomsResponseToDomain(_ response: AllRoomesModel) throws -> AllRoomesData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapMyAddressesResponseToDomain(_ response: MyAddressesModel) throws -> [MyAddressesData] {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapAddAddressResponseToDomain(_ response: AddAddressModel) throws -> AddAddressModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapDeleteAddressResponseToDomain(_ response: DeleteAddressModel) throws -> DeleteAddressModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapMakeAddressDefualtResponseToDomain(_ response: MakeAddressDefualtModel) throws -> MakeAddressDefualtModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapProfileResponseToDomain(_ response: ProfileModel) throws -> ProfileData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    
    func mapUpdateProfileResponseToDomain(_ response: UpdateProfileModel) throws -> UpdateProfileModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapLogoutResponseToDomain(_ response: LogoutModel) throws -> LogoutModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapDeleteAccountResponseToDomain(_ response: DeleteAccountModel) throws -> DeleteAccountModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapContactUsResponseToDomain(_ response: ContactUsModel) throws -> ContactUsModel {
        if response.status == 200 {
            print("✅ Remote fetch successful: \(response.message ?? "")")
            return response
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapRoomDetailsResponseToDomain(_ response: RoomDetailsModel) throws -> RoomDetailsData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapMyOrderesResponseToDomain(_ response: MyOrderesModel) throws -> MyOrderesData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapRoomItemsResponseToDomain(_ response: RoomItemsModel) throws -> RoomItemsData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapMyOrderDetailsResponseToDomain(_ response: ShowOrdereModel) throws -> ShowOrdereData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapAboutUSResponseToDomain(_ response: AboutUSModel) throws -> AboutUSData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapTermsConditionsResponseToDomain(_ response: TermsModel) throws -> TermsData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapSettingResponseToDomain(_ response: SettingModel) throws -> [SettingData] {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
    func mapPlaceOrderResponseToDomain(_ response: PlaceOrderModel) throws -> PlaceOrderData {
        if response.status == 200, let data = response.data {
            print("✅ Remote fetch successful: \(data)")
            return data
        } else if response.status == 401 {
            throw NetworkError.unauthorized
        } else {
            //throw NetworkError.general(response.message ?? "Unknown error")
            throw NetworkError.responseError(
                message: response.message ?? "Unknown error",
                statusCode: response.status ?? 0
            )
        }
    }
    
}

class TabsRemoteDataSource: TabsDataSourceProtocol {
    
    private let apiClient: NetworkLayerProtocol
    private let mapper: TabsMapperProtocol
    
    init(apiClient: NetworkLayerProtocol, mapper: TabsMapperProtocol) {
        self.apiClient = apiClient
        self.mapper = mapper
    }
    
    func mapToNetworkError(_ error: Error) -> NetworkError {
        print("❌ Error fetching remote deals: \(error)")
        
        if let networkError = error as? NetworkError {
            return networkError
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return NetworkError.noNetwork
            case .timedOut:
                return NetworkError.timeOut
            default:
                return NetworkError.general(urlError.localizedDescription)
            }
        } else {
            return NetworkError.general(error.localizedDescription)
        }
    }
    
}

extension TabsRemoteDataSource {
    
    func homeSlider() -> AnyPublisher<[HomeSliderData], NetworkError> {
        let endPoint = TabsEndPoints.homeSlider
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: HomeSliderModel) -> [HomeSliderData] in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapHomeSliderResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func homeRooms() -> AnyPublisher<[HomeRoomsData], NetworkError> {
        let endPoint = TabsEndPoints.homeRooms
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: HomeRoomsModel) -> [HomeRoomsData] in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapHomeRoomsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func homeGifts() -> AnyPublisher<[HomeGiftsData], NetworkError> {
        let endPoint = TabsEndPoints.homeGifts
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: HomeGiftsModel) -> [HomeGiftsData] in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapHomeGiftsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func homeCompletedRooms() -> AnyPublisher<[HomeCompletedRoomsData], NetworkError> {
        let endPoint = TabsEndPoints.homeCompletedRooms
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: HomeCompletedRoomsModel) -> [HomeCompletedRoomsData] in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapHomeCompletedRoomsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func allRoomes(body: AllRoomesRequest) -> AnyPublisher<AllRoomesData, NetworkError> {
        let endPoint = TabsEndPoints.allRoomes(allRoomesRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: AllRoomesModel) -> AllRoomesData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapAllRoomsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func myAddresses() -> AnyPublisher<[MyAddressesData], NetworkError> {
        let endPoint = TabsEndPoints.myAddresses
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: MyAddressesModel) -> [MyAddressesData] in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapMyAddressesResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    for item in mappedData {
                        if item.isDefault == 1 {
                            UD.address = item
                        }
                    }
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func addAddress(body: AddAddressRequest) -> AnyPublisher<AddAddressModel, NetworkError> {
        let endPoint = TabsEndPoints.addAddress(addAddressRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: AddAddressModel) -> AddAddressModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapAddAddressResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func deleteAddress(body: DeleteAddressRequest) -> AnyPublisher<DeleteAddressModel, NetworkError> {
        let endPoint = TabsEndPoints.deleteAddress(deleteAddressRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: DeleteAddressModel) -> DeleteAddressModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapDeleteAddressResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    UD.address = nil
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func makeAddressDefualt(body: MakeAddressDefualtRequest) -> AnyPublisher<MakeAddressDefualtModel, NetworkError> {
        let endPoint = TabsEndPoints.makeAddressDefualt(makeAddressDefualtRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: MakeAddressDefualtModel) -> MakeAddressDefualtModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapMakeAddressDefualtResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func profile() -> AnyPublisher<ProfileData, NetworkError> {
        let endPoint = TabsEndPoints.profile
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: ProfileModel) -> ProfileData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapProfileResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func updateProfile(body: UpdateProfileRequest) -> AnyPublisher<UpdateProfileModel, NetworkError> {
        let endPoint = TabsEndPoints.updateProfile(updateProfileRequest: body)
        
        // Setup upload data if required
        var uploadData: UploadDataModel?
        if let image = body.image {
            uploadData = UploadDataModel(
                fileName: "\(Date().timeIntervalSince1970)" + ".png",
                mimeType: "image/png",
                data: image,
                name: "image"
            )
        }
        
        // Use Combine to handle the request and possible upload
        return apiClient.upload(endPoint, uploadData: uploadData)
            .tryMap { [weak self] (response: UpdateProfileModel) -> UpdateProfileModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapUpdateProfileResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func logout() -> AnyPublisher<LogoutModel, NetworkError> {
        let endPoint = TabsEndPoints.logout
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: LogoutModel) -> LogoutModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapLogoutResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func deleteAccount() -> AnyPublisher<DeleteAccountModel, NetworkError> {
        let endPoint = TabsEndPoints.deleteAccount
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: DeleteAccountModel) -> DeleteAccountModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapDeleteAccountResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func contactUs(body: ContactUsRequest) -> AnyPublisher<ContactUsModel, NetworkError> {
        let endPoint = TabsEndPoints.contactUs(contactUsRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: ContactUsModel) -> ContactUsModel in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapContactUsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func roomeDetails(body: RoomDetailsRequest) -> AnyPublisher<RoomDetailsData, NetworkError> {
        let endPoint = TabsEndPoints.roomDetails(roomDetailsRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: RoomDetailsModel) -> RoomDetailsData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapRoomDetailsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func myOrderes(body: MyOrderesRequest) -> AnyPublisher<MyOrderesData, NetworkError> {
        let endPoint = TabsEndPoints.myOrderes(myOrderesRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: MyOrderesModel) -> MyOrderesData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapMyOrderesResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func roomItems(body: RoomItemsRequest) -> AnyPublisher<RoomItemsData, NetworkError> {
        let endPoint = TabsEndPoints.roomItems(roomItemsRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: RoomItemsModel) -> RoomItemsData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapRoomItemsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func myOrderDetails(body: ShowOrdereRequest) -> AnyPublisher<ShowOrdereData, NetworkError> {
        let endPoint = TabsEndPoints.myOrderDetails(showOrdereRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: ShowOrdereModel) -> ShowOrdereData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapMyOrderDetailsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func aboutUs() -> AnyPublisher<AboutUSData, NetworkError> {
        let endPoint = TabsEndPoints.aboutUs
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: AboutUSModel) -> AboutUSData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapAboutUSResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func temsConditions() -> AnyPublisher<TermsData, NetworkError> {
        let endPoint = TabsEndPoints.termsContidtions
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: TermsModel) -> TermsData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapTermsConditionsResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func setting() -> AnyPublisher<[SettingData], NetworkError> {
        let endPoint = TabsEndPoints.setting
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: SettingModel) -> [SettingData] in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapSettingResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}

extension TabsRemoteDataSource {
    
    func placeOrder(body: PlaceOrderRequest) -> AnyPublisher<PlaceOrderData, NetworkError> {
        let endPoint = TabsEndPoints.placeOrder(placeOrderRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: PlaceOrderModel) -> PlaceOrderData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapPlaceOrderResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    return mappedData
                } catch {
                    print("❌ Mapping error: \(error)")
                    throw error
                }
            }
            .mapError { [weak self] error in
                guard let self = self else { return NetworkError.general(error.localizedDescription) }
                return self.mapToNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
    
}
