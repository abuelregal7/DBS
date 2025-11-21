//
//  LoginUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import Combine

class LoginUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: LoginRequest) -> AnyPublisher<LoginData, NetworkError> {
        return repo.login(body: body)
    }
}
