//
//  RegisterUseCase.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 05/04/2025.
//

import Foundation
import Combine

class RegisterUseCase {
    
    private let errorSubject = PassthroughSubject<NetworkError, Never>()
    var errorPublisher: AnyPublisher<NetworkError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(body: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError> {
        return repo.register(body: body)
    }
}
