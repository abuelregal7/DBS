//
//  AuthRepositoryImplementation.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import Combine

class AuthRepository: AuthRepositoryProtocol {
    
    private let remoteDataSource: AuthRemoteDataSource
    private let mapper: AuthMapperProtocol
    
    init(remoteDataSource: AuthRemoteDataSource, mapper: AuthMapperProtocol) {
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }
}

extension AuthRepository {
    
    func login(body: LoginRequest) -> AnyPublisher<LoginData, NetworkError> {
        return remoteDataSource.login(body: body)
    }
    
}

extension AuthRepository {
    
    func verificationCode(body: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError> {
        return remoteDataSource.verificationCode(body: body)
    }
    
}

extension AuthRepository {
    
    func register(body: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError> {
        return remoteDataSource.register(body: body)
    }
    
}
