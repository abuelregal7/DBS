//
//  AuthRepositoryImplementation.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

class AuthRepository: AuthRepositoryProtocol {
    
    private let apiClient: NetworkLayerProtocol
    
    init(apiClient: NetworkLayerProtocol) {
        self.apiClient = apiClient
    }
}


extension AuthRepository {
    func login(body: LoginRequest) -> AnyPublisher<LoginData, NetworkError> {
        let endPoint = AuthEndPoint.login(loginRequest: body)
        
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: LoginModel) in
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

extension AuthRepository {
    func register(body: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError> {
        let endPoint = AuthEndPoint.register(registerRequest: body)
        
        var uploadData: UploadDataModel?
        if body.iban_image == nil {
            uploadData = nil
        }else {
            //pdfORImage = "pdf"
            //pdfORImageMimeType = "application/pdf"
            uploadData = UploadDataModel(fileName: "\(Date().timeIntervalSince1970)" + "." + "png", mimeType: "image/png", data: body.iban_image ?? Data(), name: "iban_image")
        }
        
        return apiClient.upload(endPoint, uploadData: uploadData) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: RegisterModel) in
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

extension AuthRepository {
    func verificationCode(body: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError> {
        let endPoint = AuthEndPoint.verificationCode(verificationCodeRequest: body)
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: VerificationCodeModel) in
                // Handle the response status
                if response.status == 200 {
                    // Check if data exists
                    guard let data = response.data else {
                        throw NetworkError.nullData
                    }
                    UD.accessToken = data.token
                    UD.user = data.userData
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

extension AuthRepository {
    func logout() -> AnyPublisher<LogoutModel, NetworkError> {
        let endPoint = AuthEndPoint.logout
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: LogoutModel) in
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

extension AuthRepository {
    func deleteAccount() -> AnyPublisher<DeleteAccountModel, NetworkError> {
        let endPoint = AuthEndPoint.deleteAccount
        return apiClient.request(endPoint) // This returns AnyPublisher<LoginModel, NetworkError>
            .tryMap { (response: DeleteAccountModel) in
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


