//
//  AuthRemoteDataSource.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import Combine

protocol AuthMapperProtocol {
    func mapLoginResponseToDomain(_ response: LoginModel) throws -> LoginData
    func mapVerificationCodeResponseToDomain(_ response: VerificationCodeModel) throws -> VerificationCodeData
    func mapRegisterResponseToDomain(_ response: RegisterModel) throws -> RegisterData
}

class AuthMapper: AuthMapperProtocol {
    func mapLoginResponseToDomain(_ response: LoginModel) throws -> LoginData {
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
    
    func mapVerificationCodeResponseToDomain(_ response: VerificationCodeModel) throws -> VerificationCodeData {
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
    
    func mapRegisterResponseToDomain(_ response: RegisterModel) throws -> RegisterData {
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

class AuthRemoteDataSource: AuthDataSourceProtocol {
    
    private let apiClient: NetworkLayerProtocol
    private let mapper: AuthMapperProtocol
    
    init(apiClient: NetworkLayerProtocol, mapper: AuthMapperProtocol) {
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

extension AuthRemoteDataSource {
    
    func login(body: LoginRequest) -> AnyPublisher<LoginData, NetworkError> {
        let endPoint = AuthEndPoints.login(loginRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: LoginModel) -> LoginData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapLoginResponseToDomain(response)
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

extension AuthRemoteDataSource {
    
    func verificationCode(body: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError> {
        let endPoint = AuthEndPoints.verificationCode(verificationCodeRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: VerificationCodeModel) -> VerificationCodeData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapVerificationCodeResponseToDomain(response)
                    print("✅ Remote fetch successful: \(mappedData)")
                    UD.accessToken = mappedData.token
                    UD.user = mappedData.userData
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

extension AuthRemoteDataSource {
    
    func register(body: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError> {
        let endPoint = AuthEndPoints.register(registerRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { [weak self] (response: RegisterModel) -> RegisterData in
                guard let self = self else {
                    throw NetworkError.unknown // Ensure you return or throw an error
                }
                do {
                    let mappedData = try self.mapper.mapRegisterResponseToDomain(response)
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
