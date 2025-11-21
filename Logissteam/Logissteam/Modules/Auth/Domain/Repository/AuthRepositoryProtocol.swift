//
//  AuthRepositoryProtocol.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(body: LoginRequest) -> AnyPublisher<LoginData, NetworkError>
    func register(body: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError>
    func verificationCode(body: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError>
    func logout() -> AnyPublisher<LogoutModel, NetworkError>
    func deleteAccount() -> AnyPublisher<DeleteAccountModel, NetworkError>
}
