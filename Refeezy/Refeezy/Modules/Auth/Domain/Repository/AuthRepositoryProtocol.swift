//
//  AuthRepositoryProtocol.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(body: LoginRequest) -> AnyPublisher<LoginData, NetworkError>
    func verificationCode(body: VerificationCodeRequest) -> AnyPublisher<VerificationCodeData, NetworkError>
    func register(body: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError>
}

